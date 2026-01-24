import mongoose, { Schema, Document } from 'mongoose';
import { AIMessage } from '@ai-proto/shared';

export interface ConversationDocument extends Document {
  userId: string;
  title: string;
  messages: AIMessage[];
  metadata?: Record<string, unknown>;
  createdAt: Date;
  updatedAt: Date;
}

const conversationSchema = new Schema<ConversationDocument>(
  {
    userId: {
      type: String,
      required: true,
      index: true
    },
    title: {
      type: String,
      required: true
    },
    messages: [{
      role: {
        type: String,
        enum: ['user', 'assistant', 'system'],
        required: true
      },
      content: {
        type: String,
        required: true
      },
      metadata: {
        type: Schema.Types.Mixed
      }
    }],
    metadata: {
      type: Schema.Types.Mixed
    }
  },
  {
    timestamps: true,
    toJSON: {
      transform: (_doc, ret) => {
        ret.id = ret._id.toString();
        delete ret._id;
        delete ret.__v;
        return ret;
      }
    }
  }
);

conversationSchema.index({ userId: 1, createdAt: -1 });

export const ConversationModel = mongoose.model<ConversationDocument>('Conversation', conversationSchema);
