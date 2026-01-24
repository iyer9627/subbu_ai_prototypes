import axios, { AxiosInstance } from 'axios';
import { AIRequest, AIResponse, APIResponse } from '@ai-proto/shared';

class APIClient {
  private client: AxiosInstance;
  private accessToken: string | null = null;

  constructor() {
    this.client = axios.create({
      baseURL: process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3001',
      headers: {
        'Content-Type': 'application/json',
      },
    });

    this.client.interceptors.request.use((config) => {
      if (this.accessToken) {
        config.headers.Authorization = `Bearer ${this.accessToken}`;
      }
      return config;
    });
  }

  setAccessToken(token: string | null): void {
    this.accessToken = token;
  }

  async register(email: string, password: string, name: string) {
    const response = await this.client.post<APIResponse>('/api/auth/register', {
      email,
      password,
      name,
    });
    return response.data;
  }

  async login(email: string, password: string) {
    const response = await this.client.post<APIResponse>('/api/auth/login', {
      email,
      password,
    });
    return response.data;
  }

  async sendChatRequest(request: AIRequest): Promise<APIResponse<AIResponse>> {
    const response = await this.client.post<APIResponse<AIResponse>>('/api/ai/chat', request);
    return response.data;
  }

  async *streamChatRequest(request: AIRequest): AsyncGenerator<string> {
    const response = await this.client.post('/api/ai/chat/stream', request, {
      responseType: 'stream',
      adapter: 'fetch',
    });

    const reader = response.data.getReader();
    const decoder = new TextDecoder();

    while (true) {
      const { done, value } = await reader.read();
      if (done) break;

      const chunk = decoder.decode(value);
      const lines = chunk.split('\n');

      for (const line of lines) {
        if (line.startsWith('data: ')) {
          const data = line.substring(6);
          if (data.trim()) {
            yield data;
          }
        }
      }
    }
  }
}

export const apiClient = new APIClient();
