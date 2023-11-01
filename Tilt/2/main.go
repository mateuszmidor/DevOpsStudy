package main

import (
	"fmt"
	"log"
	"net/http"
)

const address = ":8080"

func main() {
	log.Println("listening at", address)

	http.HandleFunc("/", handleAll)
	http.ListenAndServe(address, nil)
}

func handleAll(w http.ResponseWriter, r *http.Request) {
	log.Println(r.Method, r.URL.Path)

	w.WriteHeader(http.StatusOK)
	fmt.Fprint(w, "Hello world")
}
