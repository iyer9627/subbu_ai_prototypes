import { AIRequest, AIResponse, AIStreamChunk, AIProvider, Logger } from '@ai-proto/shared';
import { ProviderFactory } from './providers';

export interface AIServiceConfig {
  defaultProvider: AIProvider;
  apiKeys: {
    anthropic?: string;
    openai?: string;
  };
}

export class AIService {
  private config: AIServiceConfig;
  private logger: Logger;

  constructor(config: AIServiceConfig) {
    this.config = config;
    this.logger = new Logger('AIService');
  }

  async sendRequest(request: AIRequest): Promise<AIResponse> {
    const provider = this.getProvider(request.provider);

    this.logger.info('Processing AI request', {
      provider: request.provider,
      model: request.model
    });

    return provider.sendRequest(request);
  }

  async *streamRequest(request: AIRequest): AsyncGenerator<AIStreamChunk> {
    const provider = this.getProvider(request.provider);

    this.logger.info('Processing AI stream request', {
      provider: request.provider,
      model: request.model
    });

    yield* provider.streamRequest(request);
  }

  private getProvider(providerType: AIProvider) {
    const apiKey = this.getApiKey(providerType);
    if (!apiKey) {
      throw new Error(`API key not configured for provider: ${providerType}`);
    }

    return ProviderFactory.createProvider(providerType, apiKey);
  }

  private getApiKey(provider: AIProvider): string | undefined {
    switch (provider) {
      case AIProvider.ANTHROPIC:
        return this.config.apiKeys.anthropic;
      case AIProvider.OPENAI:
        return this.config.apiKeys.openai;
      default:
        return undefined;
    }
  }
}
