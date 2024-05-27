# Stage 1: Build the React app
FROM node:latest AS build

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the entire project to the container
COPY . .

# Build the React app
RUN npm run build

# Stage 2: Run the React app
FROM node:latest

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy only the build output and package files from the previous stage
COPY --from=build /usr/src/app/build ./build
COPY --from=build /usr/src/app/package*.json ./
COPY --from=build /usr/src/app/node_modules ./node_modules

# Install 'serve' globally
RUN npm install -g serve

# Expose port 3000
EXPOSE 3000

# Start the application using 'serve' on port 3000
CMD ["serve", "-s", "build", "-l", "3000"]
