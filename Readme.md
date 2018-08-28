# Weird OpenFL Neko Wrapper Class Getter Bug

(Related Thread: [http://community.openfl.org/t/strange-neko-bug-when-inlining-getters/10888](http://community.openfl.org/t/strange-neko-bug-when-inlining-getters/10888))

This repo demonstrates a crash I encountered when trying to create wrapper classes for OpenFL's `display` built-ins. Calling a getter function on a `Dynamic` object and inlining it as a parameter to another function messess up Neko's context, and `this` then refers to the incorrect class within the inner function call.
To see the issue in action, simply execute:
```bash
openfl test neko -debug
```
The application will immediately crash after opening with the following stack trace:
```text
Called from Main::new line 19
Called from test.MyStageWrapper::addChild line 21
Called from test.MyStage::addChild line 23
Uncaught exception - Invalid field access : addChild
```
Note that the application works fine on Flash, HXCPP, and HTML5 targets (will display the text "Worked!" if it runs successfully)

If you take a closer look at the neko source (via `-D neko-source`) you'll find the following differences between the broken and working versions-
	
**Before workaround / Broken (`instance.addChild(child.get_sprite());` in Haxe source):**
```text
 @tmp.addChild = function(value) {
        var tmp = this.stage.addChild;
        tmp(value.get_instance());
        return null;
    }
```

**After workaround 1 / Fixed (assigned getter method to var first in Haxe source):**
```text
    @tmp.addChild = function(value) {
        var ins = value.get_instance();
        this.stage.addChild(ins);
        return null;
    }
```

This indicates that the problem is related to the Neko source assigning functions from `Dynamic` objects to a temp variable. The context of said function is lost, and unexpected behavior occurs when the function is executed. (Technically this pattern would even be a problem in JavaScript, however Haxe's JS output does not extract the function to a temporary variable like the Neko output) 

It stands to reason that Neko doesn't know that the field being accessed is a function, so it doesn't think it's an issue to assign it to variable. However I think there is enough static information available to assume that addChild() was originally a function. Even if this were not the case, it was probably never necessary to create the temporary variable in the first place.

If implementing a fix for this could cause massive breaking changes for projects, I think a build warning would suffice as a fix. However I do have three possible solutions in mind that I think would be fairly safe:
	
1) Have haxe's neko output assign only objects to a tmp and not functions (when possible to infer)
2) Have haxe's neko output always remain inlined altogether instead of expanding into additional tmp vars
3) Have haxe's neko output use $call on all functions assigned from `Dynamic` vars that can be assumed to be functions (e.g. `$call(tmp, this.stage,$array(this.stage));`)


## Repo File Overview

This repo consists of a small collection of wrapper classes that are designed to augment `openfl.display` built-ins:

* **MySprite.hx** - Wraps an instance of `openfl.display.Sprite`
* **MySpriteWrapper.hx** - Wraps an instance of `MySprite`
* **MyStage.hx** -Wraps an instance of `openfl.display.Stage`
* **MyStageWrapper.hx** - Wraps an instance of `MyStage`

Each wrapper class has a getter method for retrieving the instance of the object that it is wrapping. When attempting to call `addChild()` on the `MyStageWrapper` class, Neko crashes because it seems to think that `MyStage` is an instance of `MyStageWrapper`.

## Workarounds

* Replace getter functions with basic public variables
* Assign getter to a variable first instead of inlining
* Assign types to all `Dynamic` class variables

## Libraries Used

This repo has been tested with the following library versions:

* haxe - 3.4.7
* openfl - 8.4.1
* lime - 7.0.0
* neko 2.1.0 (Also tested in 2.2.0, still bugged)

