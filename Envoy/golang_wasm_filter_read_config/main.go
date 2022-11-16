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
	extra_header_value string // read when plugin is starting
}

// Override types.DefaultPluginContext. Read plugin configuration here
func (ctx *pluginContext) OnPluginStart(pluginConfigurationSize int) types.OnPluginStartStatus {
	plugin_config_bytes, err := proxywasm.GetPluginConfiguration()
	if err != nil {
		proxywasm.LogCriticalf("error reading plugin configuration: %v", err)
		return types.OnPluginStartStatusFailed
	}
	ctx.extra_header_value = string(plugin_config_bytes) // config is a byte slice
	return types.OnPluginStartStatusOK
}

// Override types.DefaultPluginContext.
func (ctx *pluginContext) NewHttpContext(contextID uint32) types.HttpContext {
	return &httpContext{extra_header_value: ctx.extra_header_value}
}

type httpContext struct {
	// Embed the default http context here,
	// so that we don't need to reimplement all the methods.
	types.DefaultHttpContext
	extra_header_value string
}

// OnHttpRequestHeaders prints all headers received in the request to the Envoy log
func (ctx *httpContext) OnHttpRequestHeaders(numHeaders int, _ bool) types.Action {
	if headers, err := proxywasm.GetHttpRequestHeaders(); err != nil {
		proxywasm.LogErrorf("failed to get request headers with '%v'", err)
	} else {
		proxywasm.LogInfof("request headers: '%+v'", headers)
	}

	return types.ActionContinue
}

// OnHttpResponseHeaders adds a custom HTTP header to the response
func (ctx *httpContext) OnHttpResponseHeaders(int, bool) types.Action {
	proxywasm.AddHttpResponseHeader("x-wasm-filter", ctx.extra_header_value)
	return types.ActionContinue
}
