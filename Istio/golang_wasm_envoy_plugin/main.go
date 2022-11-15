package main

import (
	"github.com/tetratelabs/proxy-wasm-go-sdk/proxywasm"
	"github.com/tetratelabs/proxy-wasm-go-sdk/proxywasm/types"
)

func main() {
	proxywasm.LogInfo("Starting Envoy Plugin instance")
	proxywasm.SetVMContext(&vmContext{})
}

type vmContext struct {
	// Embed the default VM context here,
	// so that we don't need to reimplement all the methods.
	types.DefaultVMContext
}

// Override types.DefaultVMContext
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
	totalRequestBodySize int

	// Embed the default http context here,
	// so that we don't need to reimplement all the methods.
	types.DefaultHttpContext
}

// receive the request body and print it to envoy logs - to see the plugin works
func (ctx *httpContext) OnHttpRequestBody(bodySize int, endOfStream bool) types.Action {
	proxywasm.LogInfof("OnHttpRequestBody - BodySize: %v, endOfStream: %v", bodySize, endOfStream)

	ctx.totalRequestBodySize += bodySize
	if !endOfStream {
		// OnHttpRequestBody may be called each time a part of the body is received.
		// Wait until we see the entire body.
		return types.ActionPause
	}

	body, err := proxywasm.GetHttpRequestBody(0, ctx.totalRequestBodySize)
	if err != nil {
		proxywasm.LogErrorf("failed to get request body: %v", err)
		return types.ActionContinue
	}

	proxywasm.LogInfof("Request body [%d]: %v", len(body), string(body))
	return types.ActionContinue
}
