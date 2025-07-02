# Use official Node image
FROM node:18-alpine

# Create working directory
WORKDIR /usr/src/app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy application source
COPY . .

# Expose port
EXPOSE 3000

# Start the service
CMD ["node", "server.js"]