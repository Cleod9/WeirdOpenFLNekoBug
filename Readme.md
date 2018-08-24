# Weird OpenFL Neko Wrapper Class Getter Bug
This repo demonstrates a crash I encountered when trying to create wrapper classes for OpenFL's `display` built-ins. Passing a getter function's result to certain functions causes Neko's context to be incorrect, and `this` then refers to the incorrect class within the inner function call.
To see the issue in action, simply execute:
```bash
openfl test neko -debug
```
The application will immediately crash after opening with the following stack trace:
```text
Called from Main::new line 19
Called from test.MyStageWrapper::addChild line 20
Called from test.MyStage::addChild line 22
Uncaught exception - Invalid field access : addChild
```
Note that the application works fine on Flash, HXCPP, and HTML5 targets (will display the text "Worked!" if it runs successfully)

## Repo Overview

This repo consists of a small collection of wrapper classes that are designed to augment `openfl.display` built-ins:

* **MySprite.hx** - Wraps an instance of `openfl.display.Sprite`
* **MySpriteWrapper.hx** - Wraps an instance of `MySprite`
* **MyStage.hx** -Wraps an instance of `openfl.display.Stage`
* **MyStageWrapper.hx** - Wraps an instance of `MyStage`

Each wrapper class has a getter method for retrieving the instance of the object that it is wrapping. When attempting to call `addChild()` on the `MyStageWrapper` class, Neko crashes because it seems to think that `MyStage` is an instance of `MyStageWrapper`. The problem is resolved when you replace the getter function with a direct call to the field, or if you assign the getter function's result to a local variable first.

My best guess to this problem is that using a getter function call as a function argument causes Neko to lose its context temporarily. However it is unclear to me at this time if this is an issue with Neko, or an bug with the compiled Haxe code.

## Workarounds

* Replace getter functions with basic public variables
* Assign getter to a variable first instead of inlining

## Libraries Used

This repo has been tested with the following library versions:

* haxe - 3.4.7
* openfl - 8.4.1
* lime - 7.0.0
* neko 2.1.0 (Also tested in 2.2.0, still bugged)

