package main

import (
	"strconv"

	"github.com/tetratelabs/proxy-wasm-go-sdk/proxywasm"
	"github.com/tetratelabs/proxy-wasm-go-sdk/proxywasm/types"
)

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

// Override types.DefaultPluginContext. Read plugin configuration here
func (ctx *pluginContext) OnPluginStart(pluginConfigurationSize int) types.OnPluginStartStatus {
	return types.OnPluginStartStatusOK
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

// OnHttpRequestHeaders placeholder
func (ctx *httpContext) OnHttpRequestHeaders(numHeaders int, _ bool) types.Action {
	return types.ActionContinue
}

// OnHttpResponseHeaders gets, prints and increments the call counter
func (ctx *httpContext) OnHttpResponseHeaders(int, bool) types.Action {
	callCounter := GetIncCounter()
	proxywasm.LogInfof("Counter value: %v", callCounter)
	return types.ActionContinue
}

func GetIncCounter() int {
	KEY := "counter"
	var counter int
	var cas uint32
	var err error

	// try get counter value
	counter, cas, err = getCounter(KEY)

	// shared data not initialized yet; initialize now and continue
	if err == types.ErrorStatusNotFound {
		counter = 1
	}

	putCounter(KEY, counter+1, cas)
	return counter
}

func putCounter(name string, val int, cas uint32) error {
	data := []byte(strconv.Itoa(val))
	err := proxywasm.SetSharedData(name, data, cas)
	if err != nil {
		proxywasm.LogErrorf("proxywasm.SetSharedData error: %v", err)
	}
	return err
}

func getCounter(name string) (val int, cas uint32, err error) {
	VAL_ERR := -1
	var data []byte
	data, cas, err = proxywasm.GetSharedData(name)
	if err != nil {
		proxywasm.LogErrorf("proxywasm.GetSharedData error: %v", err)
		return VAL_ERR, 0, err
	}

	val, err = strconv.Atoi(string(data))
	if err != nil {
		proxywasm.LogErrorf("strconv.Atoi error: %v", err)
	}
	return val, cas, err
}
