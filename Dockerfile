# Stage 1: Build stage
FROM golang:1.26-alpine AS builder
RUN apk add --no-cache upx
WORKDIR /app
ENV CGO_ENABLED=0
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -ldflags="-s -w" -o main . && \
    upx --best --lzma main

# Stage 2: Run stage
FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/main .
EXPOSE 3000
CMD ["./main"]
