import { z } from 'zod';

export enum AIProvider {
  ANTHROPIC = 'anthropic',
  OPENAI = 'openai',
  CUSTOM = 'custom'
}

export enum AIModel {
  // Anthropic models
  CLAUDE_OPUS = 'claude-opus-4-5-20251101',
  CLAUDE_SONNET = 'claude-sonnet-4-5-20250929',
  CLAUDE_HAIKU = 'claude-3-5-haiku-20241022',

  // OpenAI models
  GPT_4_TURBO = 'gpt-4-turbo-preview',
  GPT_4 = 'gpt-4',
  GPT_35_TURBO = 'gpt-3.5-turbo'
}

export interface AIMessage {
  role: 'user' | 'assistant' | 'system';
  content: string;
  metadata?: Record<string, unknown>;
}

export interface AIRequest {
  provider: AIProvider;
  model: AIModel | string;
  messages: AIMessage[];
  temperature?: number;
  maxTokens?: number;
  systemPrompt?: string;
  tools?: AITool[];
  context?: Record<string, unknown>;
}

export interface AIResponse {
  id: string;
  content: string;
  model: string;
  provider: AIProvider;
  usage: {
    promptTokens: number;
    completionTokens: number;
    totalTokens: number;
  };
  metadata?: Record<string, unknown>;
  finishReason?: string;
}

export interface AITool {
  name: string;
  description: string;
  parameters: Record<string, unknown>;
}

export interface AIStreamChunk {
  delta: string;
  isComplete: boolean;
  metadata?: Record<string, unknown>;
}

// Zod schemas for validation
export const AIMessageSchema = z.object({
  role: z.enum(['user', 'assistant', 'system']),
  content: z.string(),
  metadata: z.record(z.unknown()).optional()
});

export const AIRequestSchema = z.object({
  provider: z.nativeEnum(AIProvider),
  model: z.string(),
  messages: z.array(AIMessageSchema),
  temperature: z.number().min(0).max(2).optional(),
  maxTokens: z.number().positive().optional(),
  systemPrompt: z.string().optional(),
  tools: z.array(z.any()).optional(),
  context: z.record(z.unknown()).optional()
});
