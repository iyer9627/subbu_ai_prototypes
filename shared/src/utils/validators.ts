import { z } from 'zod';

export class ValidationError extends Error {
  constructor(message: string, public details?: unknown) {
    super(message);
    this.name = 'ValidationError';
  }
}

export function validate<T>(schema: z.ZodSchema<T>, data: unknown): T {
  try {
    return schema.parse(data);
  } catch (error) {
    if (error instanceof z.ZodError) {
      throw new ValidationError('Validation failed', error.errors);
    }
    throw error;
  }
}

export const EmailSchema = z.string().email();
export const UUIDSchema = z.string().uuid();
export const URLSchema = z.string().url();
