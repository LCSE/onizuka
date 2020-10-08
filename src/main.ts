import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import {
  FastifyAdapter,
  NestFastifyApplication,
} from '@nestjs/platform-fastify';
import { AppModule } from './app.module';

const app_port = parseInt(process.env.APP_PORT);
async function bootstrap() {
  const app = await NestFactory.create<NestFastifyApplication>(
    AppModule,
    new FastifyAdapter({ logger: true }),
  );
  app.useGlobalPipes(new ValidationPipe());
  await app.listen(app_port, '0.0.0.0');
  console.log(
    '\x1b[33m',
    'Application is running on: ' + '\x1b[35m',
    `${await app.getUrl()}`,
    '\x1b[0m',
  );
}
bootstrap();
