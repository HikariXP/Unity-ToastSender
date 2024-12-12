# CharSui's InvokeChain
> This en readme use ChatGPT4 to translate

[Chinese](README.md)
[English](README-EN.md)

Define a general logic for an invocation chain. When you have chain-based calls in your logic, this can help standardize your call chain.

# Application Scope
## In-App Purchases
For example, before purchasing, you need to know what you are buying. You might ask the server how much it costs and check locally if any logic should modify or handle UI processing. This purchasing process is sequential; if one step fails, like failing to retrieve server pricing, the process fails.

## Resource Loading Process
Before loading resources, confirm what resources to load, such as "charsui_texture." First, check if it meets naming conventions, whether it exists in the manifest, and if the resource is available locally or remotely, then download or read directly and return the resource itself to the logic.

# How to Use
Import via Unity Git URL: https://github.com/HikariXP/CharSuiInvokeChain.git

There are only four classes, with the core logic in two classes: { InvokeChain, InvokeChainStage }. The data classes are: { InvokeData, InvokeChainContext }.

## InvokeChain
Top-level call management, responsible for initialization, calls, and pre-call processing such as passing in strings. InvokeChain also holds an array of stages and a temporary context currently used by the chain (inheriting from InvokeChainContext).

Here's what you need to do:

- Create your own class inheriting from InvokeChain.
- Override DefineStage to add your specific stages to stages.
- Override SetInvokeData, letting a class inherit InvokeData with the data you need.
- Create the call chain where needed; it initializes automatically.
- Call SetInvokeData to input your raw data for processing.
- In most cases, add post-execution processing to invokeFinishCallback as needed.
- Call Invoke().

## InvokeChainStage
The specific chain of calls. InvokeChain calls each stage in order based on the stages it holds. You can override only one method, InvokeImplementation, to perform your operations, like asynchronous waiting or synchronous actions.

**Important: Remember to call Finish() after your operations.**
Calling Finish signals the end of the current process and moves to the next stage. If there's other code after Finish(), write return to interrupt logic. For errors, pass in your own errorCode and errorMsg:

- errorCode: Allows subsequent actions in your code, like error reporting or data uploading.
- errorMsg: Helps developers identify which stage failed and what the issue was from the log.
## Example - In-Game Purchase Requirement
### Background Requirement
Using a platform's in-app purchase system, like Google Play, you need to get price information from the platform and apply a "half-price" discount on the client side before initiating the purchase. There are UI callbacks at the start and end of the purchase to display a loading mask for players.

### Implementation
This example is implemented in the sample and can be directly referenced.

1.Define a manager class IAPInvokeChain that inherits InvokeChain.
2.Define two stages corresponding to "getting platform price" and "client half-price discount," like ServerPriceStage and ClientDiscountStage. Implement your operations in their InvokeImplementation methods.
3.Ensure that each stage completes its logic with a Finish() call regardless of the logic path, signaling completion. Pass in custom error codes and messages if errors occur.
4.In the abstract method DefineStage of IAPInvokeChain, create the two stages and add them to the stages array.
5.Since we need to know what to buy before purchasing, the IAPInvokeChain should accept a parameter, managed by InvokeData.
6.Create IAPInvokeData, which contains a string variable productId, inheriting InvokeData.
7.In your logic, instantiate IAPInvokeChain where needed.
8.Create an IAPInvokeData object, inputting your data into productId.
9.Inject your callback function into invokeFinishCallback in IAPInvokeChain.
10.Call Invoke(), passing in the newly created IAPInvokeData, and have fun!