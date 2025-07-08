package main

import (
	"context"
	"database/sql"
	"fmt"
	"log"
	"net"
	"os"

	_ "github.com/lib/pq"
	"google.golang.org/grpc"

	pb "server/quote/proto"
)

type server struct {
	pb.UnimplementedQuoteServer
	db *sql.DB
}

func (s *server) GetQuote(ctx context.Context, in *pb.QuoteRequest) (*pb.QuoteResponse, error) {
	var quote string
	err := s.db.QueryRow("SELECT text FROM quotes ORDER BY RANDOM() LIMIT 1").Scan(&quote)
	if err != nil {
		log.Printf("Failed to fetch quote: %v", err)
		return nil, err
	}
	log.Printf("Fetched quote: %s", quote)
	return &pb.QuoteResponse{Quote: quote}, nil
}

func main() {
	dbUser := os.Getenv("POSTGRES_USER")
	dbPassword := os.Getenv("POSTGRES_PASSWORD")
	dbName := os.Getenv("POSTGRES_DB")
	dbHost := os.Getenv("POSTGRES_HOST")
	dbPort := os.Getenv("POSTGRES_PORT")
	dbURI := fmt.Sprintf("user=%s password=%s dbname=%s host=%s port=%s sslmode=disable", dbUser, dbPassword, dbName, dbHost, dbPort)

	db, err := sql.Open("postgres", dbURI)
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}
	defer db.Close()

	lis, err := net.Listen("tcp", ":50051")
	if err != nil {
		log.Fatalf("Failed to listen: %v", err)
	}

	s := grpc.NewServer()
	pb.RegisterQuoteServer(s, &server{db: db})

	log.Println("gRPC server listening at :50051")
	if err := s.Serve(lis); err != nil {
		log.Fatalf("Failed to serve: %v", err)
	}
}
