import mongoose, { Schema, Document } from 'mongoose';
import { User, UserRole } from '@ai-proto/shared';

export interface UserDocument extends Omit<User, 'id'>, Document {
  passwordHash: string;
}

const userSchema = new Schema<UserDocument>(
  {
    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true
    },
    name: {
      type: String,
      required: true,
      trim: true
    },
    passwordHash: {
      type: String,
      required: true
    },
    role: {
      type: String,
      enum: Object.values(UserRole),
      default: UserRole.USER
    },
    isActive: {
      type: Boolean,
      default: true
    },
    lastLoginAt: {
      type: Date
    },
    preferences: {
      theme: {
        type: String,
        enum: ['light', 'dark'],
        default: 'light'
      },
      defaultAIProvider: String,
      defaultModel: String,
      notificationsEnabled: {
        type: Boolean,
        default: true
      }
    }
  },
  {
    timestamps: true,
    toJSON: {
      transform: (_doc, ret) => {
        ret.id = ret._id.toString();
        delete ret._id;
        delete ret.__v;
        delete ret.passwordHash;
        return ret;
      }
    }
  }
);

userSchema.index({ email: 1 });

export const UserModel = mongoose.model<UserDocument>('User', userSchema);
