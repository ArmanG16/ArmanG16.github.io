# Stage 1: Build the Actix Web app
FROM rust:1.71 as builder

# Set working directory
WORKDIR /app

# Copy Cargo.toml and Cargo.lock first (to leverage Docker caching)
COPY Cargo.toml Cargo.lock ./

# Create a dummy main.rs to prefetch dependencies
RUN mkdir src && echo "fn main() {}" > src/main.rs

# Fetch dependencies (cached if Cargo.toml hasn't changed)
RUN cargo build --release || true

# Copy the actual source code into the image
COPY . .

# Build the real application
RUN cargo build --release

# Stage 2: Create a minimal runtime image
FROM debian:buster-slim

# Set working directory
WORKDIR /app

# Copy the compiled binary and static files from the builder
COPY --from=builder /app/target/release/armanwebsite /app
COPY --from=builder /app/static /app/static

# Expose the port your app listens on
EXPOSE 8080

# Run the application
CMD ["/app/armanwebsite"]
