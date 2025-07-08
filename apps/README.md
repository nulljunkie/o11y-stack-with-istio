### Compile `quote.proto`

Within this directory run

```bash
protoc --go_out=./client --go-grpc_out=./client quote.proto
protoc --go_out=./server --go-grpc_out=./server quote.proto
```
