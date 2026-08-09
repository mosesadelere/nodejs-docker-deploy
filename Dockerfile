# Use official Node image
FROM node:18-alpine AS builder

# Create working directory
WORKDIR /usr/src/app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm ci

# Copy application source
COPY . .

FROM node:18-alpine AS runtime

# Create working directory
WORKDIR /usr/src/app

ENV NODE_ENV=production

COPY package*.json ./

RUN npm ci --only=production

# Copy built application from builder stage
COPY --from=builder /usr/src/app /usr/src/app

# Expose port
EXPOSE 3000

# Start the service
CMD ["node", "server.js"]