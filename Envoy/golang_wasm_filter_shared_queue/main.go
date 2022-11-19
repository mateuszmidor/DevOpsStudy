package main

import (
	"fmt"
	"strconv"

	"github.com/tetratelabs/proxy-wasm-go-sdk/proxywasm"
	"github.com/tetratelabs/proxy-wasm-go-sdk/proxywasm/types"
)

const VM_ID = "my_vm_id"    // from envoy.yaml
const QUEUE_ID = "my_queue" // arbitrary
const INVALID_COUNTER = -1
const INVALID_QUEUE = 0

func main() {
	proxywasm.SetVMContext(&vmContext{})
}

type vmContext struct {
	// Embed the default VM context here,
	// so that we don't need to reimplement all the methods.
	types.DefaultVMContext
}

// Override types.DefaultVMContext.
func (vm *vmContext) NewPluginContext(contextID uint32) types.PluginContext {
	return &pluginContext{}
}

type pluginContext struct {
	// Embed the default plugin context here,
	// so that we don't need to reimplement all the methods.
	types.DefaultPluginContext
}

// OnQueueReady is called when there is a new item in the queue to be read
func (ctx *pluginContext) OnQueueReady(queueID uint32) {
	// not used in this example
}

// Override types.DefaultPluginContext.
func (ctx *pluginContext) NewHttpContext(contextID uint32) types.HttpContext {
	return &httpContext{}
}

type httpContext struct {
	// Embed the default http context here,
	// so that we don't need to reimplement all the methods.
	types.DefaultHttpContext
}

// OnHttpRequestHeaders gets, prints and increments the call counter
func (ctx *httpContext) OnHttpRequestHeaders(int, bool) types.Action {
	if callCounter, err := getIncCounter(); err != nil {
		proxywasm.LogErrorf("failed to getIncCounter: %v", err)
	} else {
		proxywasm.LogInfof("Counter value: %v", callCounter)
	}

	return types.ActionContinue
}

func getIncCounter() (int, error) {
	queueID, err := resolveOrRegisterQueue(VM_ID, QUEUE_ID)
	if err != nil {
		return INVALID_COUNTER, err
	}

	counter, err := getCounter(queueID)
	if err != nil {
		return INVALID_COUNTER, err
	}

	putCounter(queueID, counter+1)
	return counter, err
}

func resolveOrRegisterQueue(vmID, queueName string) (queueID uint32, err error) {
	if queueID, err = proxywasm.ResolveSharedQueue(vmID, queueName); err == types.ErrorStatusNotFound {
		proxywasm.LogInfof("Registering new SharedQueue: \"%v\"", queueName)
		queueID, err = proxywasm.RegisterSharedQueue(queueName)
		if err != nil {
			return INVALID_QUEUE, fmt.Errorf("failed to RegisterSharedQueue \"%v\": %w", queueName, err)
		}
	} else if err != nil {
		return INVALID_QUEUE, fmt.Errorf("failed to ResolveSharedQueue \"%v\": %w", queueName, err)
	}
	return queueID, nil
}

func getCounter(queueID uint32) (val int, err error) {
	var data []byte
	data, err = proxywasm.DequeueSharedQueue(queueID)
	if err == types.ErrorStatusEmpty { // no items in queue yet, return initial counter value
		return 1, nil
	} else if err != nil { // some other error; report it
		return INVALID_COUNTER, fmt.Errorf("failed to DequeueSharedQueue: %w", err)
	}

	val, err = strconv.Atoi(string(data))
	if err != nil {
		return INVALID_COUNTER, fmt.Errorf("failed to strconv.Atoi: %w", err)
	}
	return val, nil
}

func putCounter(queueID uint32, val int) error {
	data := []byte(strconv.Itoa(val))
	err := proxywasm.EnqueueSharedQueue(queueID, data)
	if err != nil {
		return fmt.Errorf("failed to EnqueueSharedQueue: %w", err)
	}
	return nil
}
