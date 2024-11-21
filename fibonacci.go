package main

import (
	"fmt"
	"log/slog"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func fibonacciHandler(ctx *gin.Context) {
	slog.Debug("Handling request", "URI", ctx.Request.RequestURI)

	number, err := strconv.Atoi(ctx.Query("number"))
	if err != nil {
		ctx.String(http.StatusBadRequest, err.Error())
		return
	}

	// Print a message before calculating Fibonacci
	message := fmt.Sprintf("Calculating Fibonacci for number: %d", number)
	slog.Info(message)

	fib := calculateFibonacci(number)

	// Include the message in the response
	response := fmt.Sprintf("%s\nFibonacci result: %d", message, fib)
	ctx.String(http.StatusOK, response)
}

func calculateFibonacci(n int) int {
	if n <= 1 {
		return n
	}
	return calculateFibonacci(n-1) + calculateFibonacci(n-2)
}