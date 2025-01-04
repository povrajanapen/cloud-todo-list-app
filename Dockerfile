# syntax=docker/dockerfile:1

FROM node:20-alpine
WORKDIR /app
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install
COPY . .
RUN yarn install --production
CMD ["node", "src/index.js","yarn", "run", "dev"]
EXPOSE 3000