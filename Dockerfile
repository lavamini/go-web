# 第一阶段：编译阶段
FROM golang:1.26-alpine AS builder
WORKDIR /app
# 开启 CGO 禁用以获得静态二进制文件
ENV CGO_ENABLED=0 GOOS=linux
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -ldflags="-s -w" -o main .

# 第二阶段：运行阶段
FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
# 从编译阶段拷贝二进制文件
COPY --from=builder /app/main .
# Fiber 默认端口通常是 3000
EXPOSE 3000
CMD ["./main"]
