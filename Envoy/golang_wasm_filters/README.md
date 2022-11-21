# Golang WASM filters

These are examples of how to write a WASM filter for Envoy using Go.  

This is helpful to understand WASM filters: https://github.com/tetratelabs/proxy-wasm-go-sdk/blob/main/doc/OVERVIEW.md

## What happens when Envoy Proxy starts

1. Envoy creates a bunch o workers
1. Each worker creates its own instance of WASM filter in its WASM VM
    - `main()` is run and VMContext is created (11 times: 10 worker threads + main thread to enable background processing - aka Envoy Service)
    - `NewPluginContext()` is run and `PluginContext` is created and `OnPluginStart()` is run (10 times - 10 worker threads)
1. On incoming HTTP request 
    - `NewHttpContext()` is run and `HTTPContext` is created
    - Handler methods of `HTTPContext` are run


##  Wasm Virtual Machine(VM) - corresponds to VM configuration

From [proxy-wasm-sdk/proxywasm/types/context.go](https://raw.githubusercontent.com/tetratelabs/proxy-wasm-go-sdk/main/proxywasm/types/context.go):

```text
    ┌────────────────────────────────────────────────────────────────────────────┐
    │                                                      TcpContext            │
    │                                                  ╱ (Each Tcp stream)       │
    │                                                 ╱                          │
    │                      1: N                      ╱ 1: N                      │
    │       VMContext  ──────────  PluginContext                                 │
    │  (VM configuration)     (Plugin configuration) ╲ 1: N                      │
    │                                                 ╲                          │
    │                                                  ╲   HttpContext           │
    │                                                   (Each Http stream)       │
    └────────────────────────────────────────────────────────────────────────────┘
```

**To summarize:**
1. VMContext corresponds to each Wasm Virtual Machine, and only one VMContext exists in each VM.  
Note that in Envoy, Wasm VMs are created per "vm_config" field in envoy.yaml. For example having different "vm_config.configuration" fields
results in multiple VMs being created and each of them corresponds to each "vm_config.configuration".  
1. VMContext is parent of PluginContext, and is responsible for creating arbitrary number of PluginContexts.
1. PluginContext corresponds to each plugin configuration in the host. In Envoy, each plugin configuration is given at HttpFilter or NetworkFilter
on listeners. That said, a plugin context corresponds to an Http or Network filter on a listener and is in charge of creating the "filter instances" for
each Http or Tcp stream. These "filter instances" are represented by HttpContexts or TcpContexts.
1. PluginContext is a parent of TcpContext and HttpContext, and is responsible for creating arbitrary number of these contexts.
1. TcpContext is responsible for handling individual Tcp stream events.
1. HttpContext is responsible for handling individual Http stream events.