'use client';

import { ChatContainer } from '@/components/chat/ChatContainer';
import { useAuthStore } from '@/store/auth-store';
import { useChatStore } from '@/store/chat-store';
import { AIProvider } from '@ai-proto/shared';

export default function Home() {
  const { isAuthenticated, user, logout } = useAuthStore();
  const { selectedProvider, selectedModel, setProvider, clearMessages } = useChatStore();

  if (!isAuthenticated) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-50 dark:bg-gray-900">
        <div className="max-w-md w-full space-y-8 p-8 bg-white dark:bg-gray-800 rounded-lg shadow-lg">
          <div>
            <h2 className="text-center text-3xl font-extrabold text-gray-900 dark:text-white">
              AI Prototyping Platform
            </h2>
            <p className="mt-2 text-center text-sm text-gray-600 dark:text-gray-400">
              Please sign in or create an account to continue
            </p>
          </div>
          <div className="mt-8 space-y-4">
            <p className="text-center text-gray-500 dark:text-gray-400">
              Authentication UI coming soon...
            </p>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="flex flex-col h-screen bg-gray-50 dark:bg-gray-900">
      <header className="bg-white dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700 p-4">
        <div className="flex items-center justify-between max-w-7xl mx-auto">
          <div>
            <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
              AI Prototyping Platform
            </h1>
            <p className="text-sm text-gray-500 dark:text-gray-400">
              Welcome, {user?.name}
            </p>
          </div>
          <div className="flex items-center gap-4">
            <select
              value={selectedProvider}
              onChange={(e) => setProvider(e.target.value as AIProvider)}
              className="px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md dark:bg-gray-700 dark:text-white"
            >
              <option value={AIProvider.ANTHROPIC}>Anthropic (Claude)</option>
              <option value={AIProvider.OPENAI}>OpenAI (GPT)</option>
            </select>
            <button
              onClick={() => clearMessages()}
              className="px-4 py-2 text-sm bg-gray-200 dark:bg-gray-700 text-gray-700 dark:text-gray-300 rounded-md hover:bg-gray-300 dark:hover:bg-gray-600"
            >
              Clear Chat
            </button>
            <button
              onClick={logout}
              className="px-4 py-2 text-sm bg-red-600 text-white rounded-md hover:bg-red-700"
            >
              Logout
            </button>
          </div>
        </div>
      </header>
      <main className="flex-1 overflow-hidden">
        <div className="h-full max-w-7xl mx-auto bg-white dark:bg-gray-800">
          <ChatContainer />
        </div>
      </main>
    </div>
  );
}
