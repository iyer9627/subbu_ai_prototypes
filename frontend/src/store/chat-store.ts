import { create } from 'zustand';
import { AIMessage, AIProvider, AIModel } from '@ai-proto/shared';

interface ChatState {
  messages: AIMessage[];
  isLoading: boolean;
  selectedProvider: AIProvider;
  selectedModel: string;
  addMessage: (message: AIMessage) => void;
  clearMessages: () => void;
  setLoading: (loading: boolean) => void;
  setProvider: (provider: AIProvider) => void;
  setModel: (model: string) => void;
}

export const useChatStore = create<ChatState>((set) => ({
  messages: [],
  isLoading: false,
  selectedProvider: AIProvider.ANTHROPIC,
  selectedModel: AIModel.CLAUDE_SONNET,

  addMessage: (message: AIMessage) =>
    set((state) => ({ messages: [...state.messages, message] })),

  clearMessages: () => set({ messages: [] }),

  setLoading: (loading: boolean) => set({ isLoading: loading }),

  setProvider: (provider: AIProvider) => set({ selectedProvider: provider }),

  setModel: (model: string) => set({ selectedModel: model }),
}));
