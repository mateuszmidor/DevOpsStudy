package main

import (
	"context"
	"errors"
	"log"
	"strings"
	"syscall"
	"time"

	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
	//
	// Uncomment to load all auth plugins
	// _ "k8s.io/client-go/plugin/pkg/client/auth"
	//
	// Or uncomment to load specific auth plugins
	// _ "k8s.io/client-go/plugin/pkg/client/auth/azure"
	// _ "k8s.io/client-go/plugin/pkg/client/auth/gcp"
	// _ "k8s.io/client-go/plugin/pkg/client/auth/oidc"
)

func main() {
	log.Print("Starting k8s-api-client")

	clientset := getClient()
	waitKubeAPIReady(clientset)
	printAllPods(clientset)
}

func getClient() *kubernetes.Clientset {
	// creates the in-cluster config
	config, err := rest.InClusterConfig()
	if err != nil {
		log.Fatal(err.Error())
	}
	// creates the clientset
	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		log.Fatal(err.Error())
	}
	return clientset
}

func waitKubeAPIReady(clientset *kubernetes.Clientset) {
	// simply call "get nodes" and retry on failure untill success
	for {
		_, err := clientset.CoreV1().Nodes().List(context.TODO(), metav1.ListOptions{})
		if errors.Is(err, syscall.ECONNREFUSED) {
			log.Print("API Server not available, retrying in 1 sec...")
			time.Sleep(time.Second)
			continue
		} else if err != nil {
			log.Fatal("failed to list Nodes:", err.Error())
		}
		break
	}
}

func printAllPods(clientset *kubernetes.Clientset) {
	// get pods in all the namespaces by omitting namespace
	// Or specify namespace to get pods in particular namespace
	pods, err := clientset.CoreV1().Pods("").List(context.TODO(), metav1.ListOptions{})
	if err != nil {
		log.Print("failed to list PODs:", err.Error())
	} else {
		log.Printf("There are %d pods in the cluster: %v\n", len(pods.Items), getPodNames(pods))
	}
}

func getPodNames(pods *v1.PodList) string {
	names := []string{}
	for _, pod := range pods.Items {
		names = append(names, pod.Name)
	}
	return strings.Join(names, ", ")
}
