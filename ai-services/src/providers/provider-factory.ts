import { AIProvider } from '@ai-proto/shared';
import { IAIProvider } from './base-provider';
import { AnthropicProvider } from './anthropic-provider';
import { OpenAIProvider } from './openai-provider';

export class ProviderFactory {
  static createProvider(provider: AIProvider, apiKey: string): IAIProvider {
    switch (provider) {
      case AIProvider.ANTHROPIC:
        return new AnthropicProvider(apiKey);
      case AIProvider.OPENAI:
        return new OpenAIProvider(apiKey);
      default:
        throw new Error(`Unsupported AI provider: ${provider}`);
    }
  }
}
