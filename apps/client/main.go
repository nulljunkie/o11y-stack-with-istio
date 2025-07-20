package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"

	pb "client/quote/proto"
)

func main() {

	serverHost := os.Getenv("SERVER_HOST")
	serverPort := os.Getenv("SERVER_PORT")
	version := os.Getenv("VERSION")
	if version == "" {
		version = "v1"
	}
	serverAddress := fmt.Sprintf("%s:%s", serverHost, serverPort)

	conn, err := grpc.Dial(serverAddress, grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()

	client := pb.NewQuoteClient(conn)

	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		response := fmt.Sprintf(`{"status": "healthy", "version": "%s"}`, version)
		w.Write([]byte(response))
	})

	http.HandleFunc("/quote", func(w http.ResponseWriter, r *http.Request) {
		ctx, cancel := context.WithTimeout(context.Background(), time.Second)
		defer cancel()

		res, err := client.GetQuote(ctx, &pb.QuoteRequest{})
		if err != nil {
			http.Error(w, "Failed to get quote", http.StatusInternalServerError)
			log.Printf("could not get quote: %v", err)
			return
		}

		w.Header().Set("X-Version", version)

		if version == "v2" {
			response := fmt.Sprintf(`{"quote": "%s", "version": "%s", "enhanced": true}`, res.GetQuote(), version)
			w.Header().Set("Content-Type", "application/json")
			w.Write([]byte(response))
		} else {
			w.Write([]byte(res.GetQuote()))
		}
	})

	log.Println("REST client listening at :8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
