export enum DatabaseType {
  MONGODB = 'mongodb',
  SUPABASE = 'supabase'
}

export interface DatabaseConfig {
  type: DatabaseType;
  connectionString?: string;
  supabaseUrl?: string;
  supabaseKey?: string;
}

export interface BaseEntity {
  id: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface QueryOptions {
  limit?: number;
  offset?: number;
  sort?: Record<string, 1 | -1>;
  filter?: Record<string, unknown>;
}

export interface PaginatedResponse<T> {
  data: T[];
  total: number;
  page: number;
  pageSize: number;
  hasMore: boolean;
}
