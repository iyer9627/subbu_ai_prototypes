import { AIRequest, AIResponse, AIStreamChunk } from '@ai-proto/shared';

export interface IAIProvider {
  sendRequest(request: AIRequest): Promise<AIResponse>;
  streamRequest(request: AIRequest): AsyncGenerator<AIStreamChunk>;
  validateConfig(): boolean;
}

export abstract class BaseAIProvider implements IAIProvider {
  protected apiKey: string;

  constructor(apiKey: string) {
    this.apiKey = apiKey;
  }

  abstract sendRequest(request: AIRequest): Promise<AIResponse>;
  abstract streamRequest(request: AIRequest): AsyncGenerator<AIStreamChunk>;

  validateConfig(): boolean {
    return !!this.apiKey && this.apiKey.length > 0;
  }

  protected generateId(): string {
    return `${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  }
}
