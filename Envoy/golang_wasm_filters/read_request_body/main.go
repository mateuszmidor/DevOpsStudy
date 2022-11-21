package main

import (
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

// Override types.DefaultPluginContext. Read plugin configuration here, if needed
func (ctx *pluginContext) OnPluginStart(pluginConfigurationSize int) types.OnPluginStartStatus {
	return types.OnPluginStartStatusOK
}

// Override types.DefaultPluginContext.
func (ctx *pluginContext) NewHttpContext(contextID uint32) types.HttpContext {
	return &httpContext{}
}

type httpContext struct {
	// Embed the default http context here, so that we don't need to reimplement all the methods.
	types.DefaultHttpContext
	totalRequestBodySize int
}

// OnHttpRequestBody handles receiving request body
func (ctx *httpContext) OnHttpRequestBody(bodySize int, endOfStream bool) types.Action {
	proxywasm.LogInfof("BodySize: %v, endOfStream: %v", bodySize, endOfStream)

	ctx.totalRequestBodySize += bodySize
	if !endOfStream {
		// OnHttpRequestBody may be called each time a part of the body is received.
		// Wait until we see the entire body.
		return types.ActionPause
	}

	body, err := proxywasm.GetHttpRequestBody(0, ctx.totalRequestBodySize)
	if err != nil {
		proxywasm.LogErrorf("Failed to get request body: %v", err)
		return types.ActionContinue
	}

	proxywasm.LogInfof("Request body: %s", string(body))

	return types.ActionContinue
}

// OnHttpRequestHeaders placeholder
func (ctx *httpContext) OnHttpRequestHeaders(numHeaders int, _ bool) types.Action {
	return types.ActionContinue
}

// OnHttpResponseHeaders. Add custom headers here, if needed
func (ctx *httpContext) OnHttpResponseHeaders(numHeaders int, endOfStream bool) types.Action {
	return types.ActionContinue
}
