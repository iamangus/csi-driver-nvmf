FROM golang:1.19 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o nvmfplugin ./cmd/nvmfplugin

FROM debian:13
RUN apt-get update && apt-get install -y e2fsprogs && apt-get clean all
COPY --from=builder /app/nvmfplugin /nvmfplugin
ENTRYPOINT ["/nvmfplugin"]
