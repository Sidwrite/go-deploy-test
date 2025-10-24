package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"time"
)

// Response структуры для JSON ответов
type HealthResponse struct {
	Status    string `json:"status"`
	Version   string `json:"version"`
	Timestamp string `json:"timestamp"`
}

type HelloResponse struct {
	Message string `json:"message"`
}

// healthHandler обрабатывает GET /health
func healthHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	response := HealthResponse{
		Status:    "ok",
		Version:   "1.0.0",
		Timestamp: time.Now().Format(time.RFC3339),
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

// rootHandler обрабатывает GET /
func rootHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	currentTime := time.Now().Format("15:04:05")
	response := HelloResponse{
		Message: fmt.Sprintf("Hello World. Now time is %s", currentTime),
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func main() {
	// Настройка маршрутов
	http.HandleFunc("/", rootHandler)
	http.HandleFunc("/health", healthHandler)

	// Запуск сервера
	port := ":8080"
	fmt.Printf("Server starting on port %s\n", port)
	fmt.Println("Available endpoints:")
	fmt.Println("  GET /       - Hello World with time")
	fmt.Println("  GET /health - Health check")
	
	log.Fatal(http.ListenAndServe(port, nil))
}
