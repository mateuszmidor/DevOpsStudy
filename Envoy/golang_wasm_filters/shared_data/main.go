package main

import (
	"fmt"
	"strconv"

	"github.com/tetratelabs/proxy-wasm-go-sdk/proxywasm"
	"github.com/tetratelabs/proxy-wasm-go-sdk/proxywasm/types"
)

const COUNTER_NAME = "my-counter"
const INVALID_COUNTER = -1

func main() {
	proxywasm.SetVMContext(&vmContext{})
}

type vmContext struct {
	// Embed the default VM context here,
	// so that we don't need to reimplement all the methods.
	types.DefaultVMContext
}

// Override types.DefaultVMContext.
func (*vmContext) NewPluginContext(contextID uint32) types.PluginContext {
	return &pluginContext{}
}

type pluginContext struct {
	// Embed the default plugin context here,
	// so that we don't need to reimplement all the methods.
	types.DefaultPluginContext
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

// OnHttpRequestHeaders  gets, prints and increments the call counter
func (ctx *httpContext) OnHttpRequestHeaders(numHeaders int, _ bool) types.Action {
	if callCounter, err := GetIncCounter(); err != nil {
		proxywasm.LogErrorf("failed to GetIncCounter: %v", err)
	} else {
		proxywasm.LogInfof("Counter value: %v", callCounter)
	}
	return types.ActionContinue
}

func GetIncCounter() (int, error) {
	counter, cas, err := getCounter(COUNTER_NAME)
	if err != nil {
		return INVALID_COUNTER, fmt.Errorf("failed to getCounter: %w", err)
	}
	err = putCounter(COUNTER_NAME, counter+1, cas)
	if err != nil {
		return INVALID_COUNTER, fmt.Errorf("failed to putCounter: %w", err)
	}
	return counter, nil
}

func putCounter(name string, val int, cas uint32) error {
	data := []byte(strconv.Itoa(val))
	err := proxywasm.SetSharedData(name, data, cas)
	if err != nil {
		proxywasm.LogErrorf("proxywasm.SetSharedData error: %v", err)
	}
	return err
}

func getCounter(key string) (val int, cas uint32, err error) {
	var data []byte
	data, cas, err = proxywasm.GetSharedData(key)

	if err == types.ErrorStatusNotFound { // shared data not initialized yet; return counter initial value
		return 1, cas, nil
	} else if err != nil { // some other error; report
		return INVALID_COUNTER, 0, fmt.Errorf("failed to GetSharedData: %w", err)
	}

	val, err = strconv.Atoi(string(data))
	if err != nil {
		return INVALID_COUNTER, cas, fmt.Errorf("failed to strconv.Atoi: %w", err)
	}
	return val, cas, err
}
