'use client';

import React, { useCallback } from 'react';
import { ChatMessage } from './ChatMessage';
import { ChatInput } from './ChatInput';
import { useChatStore } from '@/store/chat-store';
import { apiClient } from '@/lib/api-client';

export const ChatContainer: React.FC = () => {
  const { messages, isLoading, selectedProvider, selectedModel, addMessage, setLoading } =
    useChatStore();

  const handleSendMessage = useCallback(
    async (content: string) => {
      addMessage({ role: 'user', content });
      setLoading(true);

      try {
        const response = await apiClient.sendChatRequest({
          provider: selectedProvider,
          model: selectedModel,
          messages: [...messages, { role: 'user', content }],
        });

        if (response.success && response.data) {
          addMessage({
            role: 'assistant',
            content: response.data.content,
          });
        }
      } catch (error) {
        console.error('Error sending message:', error);
        addMessage({
          role: 'assistant',
          content: 'Sorry, an error occurred while processing your request.',
        });
      } finally {
        setLoading(false);
      }
    },
    [messages, selectedProvider, selectedModel, addMessage, setLoading]
  );

  return (
    <div className="flex flex-col h-full">
      <div className="flex-1 overflow-y-auto p-4 space-y-4">
        {messages.length === 0 ? (
          <div className="flex items-center justify-center h-full text-gray-500 dark:text-gray-400">
            <p>Start a conversation with the AI assistant</p>
          </div>
        ) : (
          messages.map((message, index) => (
            <ChatMessage key={index} message={message} />
          ))
        )}
        {isLoading && (
          <div className="flex justify-start">
            <div className="bg-gray-100 dark:bg-gray-800 rounded-lg p-4">
              <div className="flex space-x-2">
                <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce"></div>
                <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce delay-100"></div>
                <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce delay-200"></div>
              </div>
            </div>
          </div>
        )}
      </div>
      <div className="border-t border-gray-200 dark:border-gray-700 p-4">
        <ChatInput onSend={handleSendMessage} disabled={isLoading} />
      </div>
    </div>
  );
};
