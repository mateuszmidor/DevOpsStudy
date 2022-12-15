package main

import (
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()
	router.NoRoute(httpAnythingHandler)

	router.Run(":80")
}

func httpAnythingHandler(c *gin.Context) {
	fmt.Printf("---------------------------------------------------------------\n")
	fmt.Printf("Received %s %s, num headers: %d, content len: %d\n", c.Request.Method, c.Request.RequestURI, len(c.Request.Header), c.Request.ContentLength)
	fmt.Printf("Headers: %v\n", c.Request.Header)

	requestBody, err := c.GetRawData()
	if err != nil {
		fmt.Printf("ERROR: failed to GetRawData: %+v\n", err)
		c.JSON(http.StatusInternalServerError, err)
		return
	}

	fmt.Printf("Body: %s\n", requestBody)
	responseBody := fmt.Sprintf("Request: %s %s\nHeaders: %v\nBody: %s\n", c.Request.Method, c.Request.RequestURI, c.Request.Header, requestBody)
	c.Data(http.StatusOK, "text/html", []byte(responseBody))
}
