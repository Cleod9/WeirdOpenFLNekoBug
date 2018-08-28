# Weird OpenFL Neko Wrapper Class Getter Bug

(Related Thread: [http://community.openfl.org/t/strange-neko-bug-when-inlining-getters/10888](http://community.openfl.org/t/strange-neko-bug-when-inlining-getters/10888))

This is an even more minimal example of the problem demonstrated on `master`. See `master` branch for further details.

To see the issue in action, simply execute:
```bash
haxe build.hxml
neko MyProgram.n
```

The application will immediately crash after opening with the following stack trace:
```text
ObjInnerWrapper.hx:14: ObjInnerWrapper reported as: ObjOuterWrapper
Called from ? line 1
Called from Main.hx line 11
Called from ObjOuterWrapper.hx line 22
Called from ObjInnerWrapper.hx line 16
Uncaught exception - Invalid field access : a
```
Note that the application works fine on Flash, HXCPP, and HTML5 targets (will display the text "Worked!" if it runs successfully)

If you take a closer look at the neko source (via `-D neko-source`) you'll find the following differences between the broken and working versions-
	
**ObjOuterWrapper `a()` function in neko source before any workaround:**
```text
@tmp.a = function(value) {
    var tmp = this.inner_wrapper.a;
    tmp(value.get_instance());
    return null;
}
```

This is a problem because `a` is a function, and if assigned to a temporary variable first it will lose its context. But if all instances of `Dynamic` are replaced with types, Haxe will output working code:

**All `Dynamic` types removed:**
```text
@tmp.a = function(value) {
    var tmp = this.inner_wrapper;
    tmp.a(value.get_instance());
    return null;
}
```

## Repo File Overview

This repo consists of a small collection of wrapper classes that are designed to augment `openfl.display` built-ins:

* **ObjInnerWrapper.hx** - Wraps a `Dynamic` object that contains the class method `a` (The example wraps `WrappedObject`)
* **ObjOutterWrapper.hx** - Wraps an instance of `ObjInnerWrapper`
* **WrappedObject.hx** - The object we want to wrap deep within `ObjInnerWrap`
* **Main.hx** - Entry point that creates `ObjOutterWrapper` and `WrappedObject` instances 

## Workarounds

* Assign getter to a variable first instead of inlining
* Replace getter functions with basic public variables
* Assign types to all `Dynamic` class variables

## Libraries Used

This repo has been tested with the following library versions:

* haxe - 3.4.7
* neko 2.1.0 (Also tested in 2.2.0, still bugged)
