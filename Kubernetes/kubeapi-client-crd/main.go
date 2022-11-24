package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"

	"github.com/mateuszmidor/DevOpsStudy/Kubernetes/api-client/utils"
	istio "istio.io/client-go/pkg/apis/extensions/v1alpha1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime"
	"k8s.io/apimachinery/pkg/runtime/schema"
	"k8s.io/apimachinery/pkg/types"
	"k8s.io/client-go/dynamic"
	_ "k8s.io/client-go/plugin/pkg/client/auth"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"
)

var kubeContext = "" // kube context to use when running the example from outside the cluster. Empty means: use default

// Group Version Resource which represents an Istio WasmPlugin
var wasm = schema.GroupVersionResource{
	Group:    "extensions.istio.io",
	Version:  "v1alpha1",
	Resource: "wasmplugins",
}

//  patchObjectValue specifies a patch operation for an object
type patchObjectValue struct {
	Op    string      `json:"op"`
	Path  string      `json:"path"`
	Value interface{} `json:"value"`
}

func main() {
	// dynamicClient := getOutOfClusterClient() // for running from outside the cluster
	dynamicClient := getInClusterClient() // for running from inside a POD

	log.Print("Listing WasmPlugins")
	plugins, err := listWasmPlugins(dynamicClient)
	if err != nil {
		log.Printf("failed to getWasmPlugins: %v", err)
		return
	}
	utils.PrettyPrint(plugins)

	const pluginName = "my-wasm-plugin-1"
	const namespace = "default"
	log.Printf("Patching '%s' plugin config in '%s' namespace", pluginName, namespace)
	newConfig := map[string]bool{"config-updated": true}
	err = patchWasmPluginConfig(dynamicClient, pluginName, namespace, newConfig)
	if err != nil {
		log.Printf("failed to patchWasmPluginConfig: %v", err)
		return
	}

	log.Print("Listing WasmPlugins again")
	plugins, err = listWasmPlugins(dynamicClient)
	if err != nil {
		log.Printf("failed to getWasmPlugins: %v", err)
		return
	}
	utils.PrettyPrint(plugins)
}

// Client for accessing KubeAPI from inside a POD
func getInClusterClient() dynamic.Interface {
	config, err := rest.InClusterConfig()

	if err != nil {
		log.Fatal(err.Error())
	}

	return makeClient(config)
}

// Client for accessing KubeAPI from local machine - using local kube config
func getOutOfClusterClient() dynamic.Interface {
	log.Printf("Connecting to Kubernetes Context %v\n", kubeContext)

	config, err := clientcmd.NewNonInteractiveDeferredLoadingClientConfig(
		clientcmd.NewDefaultClientConfigLoadingRules(),
		&clientcmd.ConfigOverrides{CurrentContext: kubeContext}).ClientConfig()

	if err != nil {
		log.Fatal(err.Error())
	}

	return makeClient(config)
}

func makeClient(config *rest.Config) dynamic.Interface {
	// Creates the dynamic interface.
	dynamicClient, err := dynamic.NewForConfig(config)
	if err != nil {
		log.Fatal(err.Error())
	}
	return dynamicClient
}

func listWasmPlugins(client dynamic.Interface) ([]istio.WasmPlugin, error) {
	// get items
	list, err := client.Resource(wasm).List(context.Background(), metav1.ListOptions{})
	if err != nil {
		return nil, err
	}

	// convert unstructured items to actual list of WasmPlugins
	var result []istio.WasmPlugin
	var plugin istio.WasmPlugin
	for _, item := range list.Items {
		err = runtime.DefaultUnstructuredConverter.FromUnstructured(item.Object, &plugin)
		if err != nil {
			return nil, fmt.Errorf("failed to FromUnstructured: %w", err)
		}
		result = append(result, plugin)
	}

	return result, nil
}

func patchWasmPluginConfig(client dynamic.Interface, pluginName, namespace string, config interface{}) error {
	patch := patchObjectValue{
		Op:    "replace",
		Path:  "/spec/pluginConfig",
		Value: config,
	}
	patches := []patchObjectValue{patch}
	patchBytes, _ := json.Marshal(patches)
	_, err := client.Resource(wasm).Namespace(namespace).Patch(context.Background(), pluginName, types.JSONPatchType, patchBytes, metav1.PatchOptions{})
	return err
}
