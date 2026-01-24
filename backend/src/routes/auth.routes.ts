import { Router } from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { UserModel } from '../database/models';
import { BadRequestError, UnauthorizedError, Logger } from '@ai-proto/shared';
import { config } from '../config';

const router = Router();
const logger = new Logger('AuthRoutes');

router.post('/register', async (req, res, next) => {
  try {
    const { email, password, name } = req.body;

    if (!email || !password || !name) {
      throw new BadRequestError('Email, password, and name are required');
    }

    const existingUser = await UserModel.findOne({ email });
    if (existingUser) {
      throw new BadRequestError('User already exists');
    }

    const passwordHash = await bcrypt.hash(password, 10);
    const user = await UserModel.create({
      email,
      name,
      passwordHash
    });

    const token = jwt.sign(
      { userId: user.id },
      config.auth.jwtSecret,
      { expiresIn: config.auth.jwtExpiresIn }
    );

    logger.info('User registered successfully', { userId: user.id });

    res.status(201).json({
      success: true,
      data: {
        user: user.toJSON(),
        accessToken: token
      }
    });
  } catch (error) {
    next(error);
  }
});

router.post('/login', async (req, res, next) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      throw new BadRequestError('Email and password are required');
    }

    const user = await UserModel.findOne({ email });
    if (!user) {
      throw new UnauthorizedError('Invalid credentials');
    }

    const isPasswordValid = await bcrypt.compare(password, user.passwordHash);
    if (!isPasswordValid) {
      throw new UnauthorizedError('Invalid credentials');
    }

    user.lastLoginAt = new Date();
    await user.save();

    const token = jwt.sign(
      { userId: user.id },
      config.auth.jwtSecret,
      { expiresIn: config.auth.jwtExpiresIn }
    );

    logger.info('User logged in successfully', { userId: user.id });

    res.json({
      success: true,
      data: {
        user: user.toJSON(),
        accessToken: token
      }
    });
  } catch (error) {
    next(error);
  }
});

export default router;
