---
title: go使用grpc和grpc_gateway 
copyright_url: https://github.com
cover:  https://grpc.io/img/logos/grpc-icon-color.png
---

# 引言
&emsp;&emsp;在微服务架构中，gRPC因其**高性能**和强类型接口而广受欢迎。但是，有时我们也需要提供http请求。gRPC-Gateway是一个强大的工具，允许我们**同时支持**gRPC和http，而无需编写两套代码。本文将介绍如何使用Go语言结合gRPC和gRPC-Gateway构建高效的API服务。

# 环境准备

首先，确保已经安装了以下工具：

    Go (1.16+)
    Protocol Buffers编译器 (protoc)
    gRPC和gRPC-Gateway插件

## 安装protoc编译器

参考：https://grpc.io/docs/protoc-installation/

## 安装go插件
可以全部安装最新版本，也可以指定版本
```bash
go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2
go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@v2.10
go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@v2.10
```

# 项目结构
```
my-grpc-project/
├── api/
│   ├── hello/
│   │   └── hello.proto 
│   └── google/api
│       ├── annotations.proto
│       └── http.proto 
│   ├── server/
│   │   └── main.go
│   └── gateway/
│       └── main.go
├── internal/
│   └── hello/
│       ├── service.go
│       └── service_test.go
└── go.mod
```

# 定义Proto文件

在api/hello/hello.proto中定义：

```proto
syntax = "proto3";

package hello;
option go_package = "github.com/yourusername/my-grpc-project/api/hello";

import "google/api/annotations.proto";

service HelloService {
  rpc SayHello (HelloRequest) returns (HelloResponse) {
    option (google.api.http) = {
      post: "/v1/hello"
      body: "*"
    };
  }
}

message HelloRequest {
  string name = 1;
}

message HelloResponse {
  string message = 1;
}
```

从github中下载google的proto文件,下载链接
```http
https://github.com/googleapis/googleapis/blob/master/google/api/annotations.proto
https://github.com/googleapis/googleapis/blob/master/google/api/http.proto
```
存放到api/google/api/中

# 生成代码

使用以下命令：
```bash
# 生成gRPC代码
protoc --proto_path=./api/hello \
   --go_out=/api/hello --go_opt=paths=source_relative \
  --go-grpc_out=/api/hello --go-grpc_opt=paths=source_relative \
  --grpc-gateway_out=/api/hello --grpc-gateway_opt=paths=source_relative \
 ./api/hello/hello.proto
```

# 实现gRPC服务

在internal/hello/service.go中实现服务逻辑：

```go
package hello

import (
	"context"

	"github.com/yourusername/my-grpc-project/api/hello"
)

type Server struct {
	hello.UnimplementedHelloServiceServer
}

func (s *Server) SayHello(ctx context.Context, req *hello.HelloRequest) (*hello.HelloResponse, error) {
	return &hello.HelloResponse{
		Message: "Hello " + req.GetName(),
	}, nil
}
```
# 创建gRPC服务器

在cmd/server/main.go中创建gRPC服务器：

```go
package main

import (
	"log"
	"net"

	"github.com/yourusername/my-grpc-project/api/hello"
	"github.com/yourusername/my-grpc-project/internal/hello"
	"google.golang.org/grpc"
)

func main() {
	lis, err := net.Listen("tcp", ":50051")
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	s := grpc.NewServer()
	helloService := &hello.Server{}
	hello.RegisterHelloServiceServer(s, helloService)
	reflection.Register(s) // 加入反射，方便使用grpcurl测试
	log.Println("gRPC server started on :50051")
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
```

# 创建gRPC-Gateway

在cmd/gateway/main.go中创建：

```
package main

import (
	"context"
	"log"
	"net/http"

	"github.com/grpc-ecosystem/grpc-gateway/v2/runtime"
	"github.com/yourusername/my-grpc-project/api/hello"
	"google.golang.org/grpc"
)

func main() {
	ctx := context.Background()
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()

	mux := runtime.NewServeMux()
	opts := []grpc.DialOption{grpc.WithInsecure()}
	
	err := hello.RegisterHelloServiceHandlerFromEndpoint(ctx, mux, "localhost:50051", opts)
	if err != nil {
		log.Fatalf("failed to register gateway: %v", err)
	}

	log.Println("gRPC-Gateway server started on :8080")
	if err := http.ListenAndServe(":8080", mux); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
```

# 测试服务

## 启动gRPC服务器：

```go
go run cmd/server/main.go
```

## 启动gRPC-Gateway：
```go
go run cmd/gateway/main.go
```

## 测试http：
`curl -X POST http://localhost:8080/v1/hello -d '{"name": "World"}'`

预期输出：

{"message":"Hello World"}

## 测试grpc：

使用grpcurl,和curl语法类似，但一定要打开refection

### grpcurl
安装grpcurl:
```bash
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
```

执行命令

`grpcurl -plaintext -d '{"name":"world"}' 127.0.0.1:50051 hello.HelloService/SayHello`

预期结果：

{"message":"Hello World"}
    
