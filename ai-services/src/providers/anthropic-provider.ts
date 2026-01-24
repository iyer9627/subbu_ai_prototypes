import Anthropic from '@anthropic-ai/sdk';
import { BaseAIProvider } from './base-provider';
import { AIRequest, AIResponse, AIStreamChunk, AIProvider, Logger } from '@ai-proto/shared';

export class AnthropicProvider extends BaseAIProvider {
  private client: Anthropic;
  private logger: Logger;

  constructor(apiKey: string) {
    super(apiKey);
    this.client = new Anthropic({ apiKey });
    this.logger = new Logger('AnthropicProvider');
  }

  async sendRequest(request: AIRequest): Promise<AIResponse> {
    try {
      this.logger.info('Sending request to Anthropic', { model: request.model });

      const messages = request.messages.map(msg => ({
        role: msg.role === 'system' ? 'user' as const : msg.role,
        content: msg.content
      }));

      const response = await this.client.messages.create({
        model: request.model,
        max_tokens: request.maxTokens || 4096,
        temperature: request.temperature || 0.7,
        system: request.systemPrompt,
        messages: messages.filter(m => m.role !== 'system')
      });

      const content = response.content[0];
      const textContent = content.type === 'text' ? content.text : '';

      return {
        id: response.id,
        content: textContent,
        model: response.model,
        provider: AIProvider.ANTHROPIC,
        usage: {
          promptTokens: response.usage.input_tokens,
          completionTokens: response.usage.output_tokens,
          totalTokens: response.usage.input_tokens + response.usage.output_tokens
        },
        finishReason: response.stop_reason || undefined
      };
    } catch (error) {
      this.logger.error('Error sending request to Anthropic', error as Error);
      throw error;
    }
  }

  async *streamRequest(request: AIRequest): AsyncGenerator<AIStreamChunk> {
    try {
      this.logger.info('Starting stream request to Anthropic', { model: request.model });

      const messages = request.messages.map(msg => ({
        role: msg.role === 'system' ? 'user' as const : msg.role,
        content: msg.content
      }));

      const stream = await this.client.messages.create({
        model: request.model,
        max_tokens: request.maxTokens || 4096,
        temperature: request.temperature || 0.7,
        system: request.systemPrompt,
        messages: messages.filter(m => m.role !== 'system'),
        stream: true
      });

      for await (const chunk of stream) {
        if (chunk.type === 'content_block_delta' && chunk.delta.type === 'text_delta') {
          yield {
            delta: chunk.delta.text,
            isComplete: false
          };
        } else if (chunk.type === 'message_stop') {
          yield {
            delta: '',
            isComplete: true
          };
        }
      }
    } catch (error) {
      this.logger.error('Error streaming from Anthropic', error as Error);
      throw error;
    }
  }
}
