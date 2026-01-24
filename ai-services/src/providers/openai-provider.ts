import OpenAI from 'openai';
import { BaseAIProvider } from './base-provider';
import { AIRequest, AIResponse, AIStreamChunk, AIProvider, Logger } from '@ai-proto/shared';

export class OpenAIProvider extends BaseAIProvider {
  private client: OpenAI;
  private logger: Logger;

  constructor(apiKey: string) {
    super(apiKey);
    this.client = new OpenAI({ apiKey });
    this.logger = new Logger('OpenAIProvider');
  }

  async sendRequest(request: AIRequest): Promise<AIResponse> {
    try {
      this.logger.info('Sending request to OpenAI', { model: request.model });

      const messages: OpenAI.Chat.ChatCompletionMessageParam[] = request.messages.map(msg => ({
        role: msg.role,
        content: msg.content
      }));

      if (request.systemPrompt) {
        messages.unshift({
          role: 'system',
          content: request.systemPrompt
        });
      }

      const response = await this.client.chat.completions.create({
        model: request.model,
        messages,
        temperature: request.temperature || 0.7,
        max_tokens: request.maxTokens
      });

      const choice = response.choices[0];

      return {
        id: response.id,
        content: choice.message.content || '',
        model: response.model,
        provider: AIProvider.OPENAI,
        usage: {
          promptTokens: response.usage?.prompt_tokens || 0,
          completionTokens: response.usage?.completion_tokens || 0,
          totalTokens: response.usage?.total_tokens || 0
        },
        finishReason: choice.finish_reason || undefined
      };
    } catch (error) {
      this.logger.error('Error sending request to OpenAI', error as Error);
      throw error;
    }
  }

  async *streamRequest(request: AIRequest): AsyncGenerator<AIStreamChunk> {
    try {
      this.logger.info('Starting stream request to OpenAI', { model: request.model });

      const messages: OpenAI.Chat.ChatCompletionMessageParam[] = request.messages.map(msg => ({
        role: msg.role,
        content: msg.content
      }));

      if (request.systemPrompt) {
        messages.unshift({
          role: 'system',
          content: request.systemPrompt
        });
      }

      const stream = await this.client.chat.completions.create({
        model: request.model,
        messages,
        temperature: request.temperature || 0.7,
        max_tokens: request.maxTokens,
        stream: true
      });

      for await (const chunk of stream) {
        const delta = chunk.choices[0]?.delta?.content;
        const isComplete = chunk.choices[0]?.finish_reason !== null;

        if (delta) {
          yield {
            delta,
            isComplete: false
          };
        }

        if (isComplete) {
          yield {
            delta: '',
            isComplete: true
          };
        }
      }
    } catch (error) {
      this.logger.error('Error streaming from OpenAI', error as Error);
      throw error;
    }
  }
}
