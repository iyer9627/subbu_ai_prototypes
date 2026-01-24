export enum LogLevel {
  DEBUG = 'debug',
  INFO = 'info',
  WARN = 'warn',
  ERROR = 'error'
}

export interface LogEntry {
  level: LogLevel;
  message: string;
  timestamp: Date;
  context?: Record<string, unknown>;
  error?: Error;
}

export class Logger {
  private context: string;

  constructor(context: string) {
    this.context = context;
  }

  private log(level: LogLevel, message: string, meta?: Record<string, unknown>): void {
    const entry: LogEntry = {
      level,
      message: `[${this.context}] ${message}`,
      timestamp: new Date(),
      context: meta
    };

    const logString = JSON.stringify(entry, null, 2);

    switch (level) {
      case LogLevel.DEBUG:
        console.debug(logString);
        break;
      case LogLevel.INFO:
        console.info(logString);
        break;
      case LogLevel.WARN:
        console.warn(logString);
        break;
      case LogLevel.ERROR:
        console.error(logString);
        break;
    }
  }

  debug(message: string, meta?: Record<string, unknown>): void {
    this.log(LogLevel.DEBUG, message, meta);
  }

  info(message: string, meta?: Record<string, unknown>): void {
    this.log(LogLevel.INFO, message, meta);
  }

  warn(message: string, meta?: Record<string, unknown>): void {
    this.log(LogLevel.WARN, message, meta);
  }

  error(message: string, error?: Error, meta?: Record<string, unknown>): void {
    this.log(LogLevel.ERROR, message, { ...meta, error: error?.stack });
  }
}
