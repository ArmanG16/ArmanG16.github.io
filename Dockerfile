# Stage 1: Build the Rust application
FROM rust:1.73 as builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Cargo.toml and Cargo.lock first to cache dependencies
COPY Cargo.toml Cargo.lock ./

# Create an empty directory to simulate the source for caching dependencies
RUN mkdir src
RUN echo "fn main() { println!(\"placeholder\"); }" > src/main.rs

# Pre-build the dependencies
RUN cargo build --release || true

# Now copy the actual source code and build
COPY . .
RUN cargo build --release

# Stage 2: Create a minimal runtime environment
FROM debian:buster-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the compiled binary from the builder stage
COPY --from=builder /app/target/release/ArmanWebsite /app/

# Copy static files for your application
COPY static /app/static

# Expose the port your Actix application uses
EXPOSE 8080

# Set the default command to run the application
CMD ["/app/ArmanWebsite"]
