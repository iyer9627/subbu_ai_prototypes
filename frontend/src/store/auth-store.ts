import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import { User } from '@ai-proto/shared';
import { apiClient } from '@/lib/api-client';

interface AuthState {
  user: User | null;
  accessToken: string | null;
  isAuthenticated: boolean;
  login: (email: string, password: string) => Promise<void>;
  register: (email: string, password: string, name: string) => Promise<void>;
  logout: () => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null,
      accessToken: null,
      isAuthenticated: false,

      login: async (email: string, password: string) => {
        const response = await apiClient.login(email, password);
        if (response.success && response.data) {
          const { user, accessToken } = response.data as any;
          apiClient.setAccessToken(accessToken);
          set({ user, accessToken, isAuthenticated: true });
        }
      },

      register: async (email: string, password: string, name: string) => {
        const response = await apiClient.register(email, password, name);
        if (response.success && response.data) {
          const { user, accessToken } = response.data as any;
          apiClient.setAccessToken(accessToken);
          set({ user, accessToken, isAuthenticated: true });
        }
      },

      logout: () => {
        apiClient.setAccessToken(null);
        set({ user: null, accessToken: null, isAuthenticated: false });
      },
    }),
    {
      name: 'auth-storage',
    }
  )
);
