import { BaseEntity } from './database.types';

export interface User extends BaseEntity {
  email: string;
  name: string;
  role: UserRole;
  isActive: boolean;
  lastLoginAt?: Date;
  preferences?: UserPreferences;
}

export enum UserRole {
  ADMIN = 'admin',
  USER = 'user',
  DEVELOPER = 'developer'
}

export interface UserPreferences {
  theme?: 'light' | 'dark';
  defaultAIProvider?: string;
  defaultModel?: string;
  notificationsEnabled?: boolean;
}

export interface AuthToken {
  accessToken: string;
  refreshToken?: string;
  expiresAt: Date;
  userId: string;
}
