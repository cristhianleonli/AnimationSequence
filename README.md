# AnimationSequence

SwiftUI tool that allows building complex sequence of animations more easily by hiding animation dispatching details.

## Platforms
- iOS(.v13)
- tvOS(.v13)
- watchOS(.v6)
- macOS(.v11)

## What's in the box
- `AnimationSequence.swift`
- `AnimationConfiguration.swift`
- `AnimationEasing`
- `AnimationDefaults`

## Usage

`AnimationSequence` is meant to be flexible enough to allow you write more readable code. Here you have some many examples of what it looks like to write animation sequences. As almost all parameters are optional and nil by default(similar to SwiftUI syntax), it will let you write animation blocks more easily.


### Default values
AnimationSequence init function takes optional arguments, they will default to `AnimationDefaults`.
In this sample, two animation blocks are added to the sequence, and the start function is called at the end.

```swift
// takes the default values and applies it to all animations in the chain
AnimationSequence()
    .append {
        state.offsetX = 10
        state.color = .red
    }
    .append {
        state = AnimationState()
    }
    .start()
```

### Common values
When creating an instance of AnimationSequence with parameters, those will be applied to all animations in the sequence that don't have specific values.

```swift
// Set values for all animations in the chain
AnimationSequence(duration: 0.5, delay: 0, easing: .default)
    .append {
        state.offsetX = 10
        state.color = .red
    }
    .append {
        state = AnimationState()
    }
    .start()
```

A handy function `commonConfig()` is also available, to set the common animation values at any time in the sequence. The place where this function is called **does** matter, since from that point onwards, all new animations added to the sequence will have these values.

```swift
AnimationSequence()
    .append {
        // ...
    }
    .commonConfig(duration: 0.5, delay: 0, easing: .default)
    .append {
        // ...
    }
    .start()
```

### Specific values
In this sequence, animations have specific values, which will overwrite the global values.
Any non-given value will be default to globals or fallback to `AnimationDefaults` otherwise.

```swift
AnimationSequence()
    // only this animation will have duration of 0.5
    .append(duration: 0.5) {
        state.offsetX = 10
        state.color = .red
    }
    // only this animation will have delay of 0.3
    .append(delay: 0.3) {
        state = AnimationState()
    }
    .start()
```

### Async
Appending animations will always keep them one after the other, but in case you need an animation triggered but not awaited, async is the solution. Let's pictures the animation sequence as follows:
```swift
 (A)==>(B)==|      |==>(E)
            |==>(C)
            |==>(D)

// Animation A starts, then comes B, at that moment, we trigger C and D without waiting for them.
// then finally, right after B, comes E and the sequence ends.
```

```swift
AnimationSequence()
    // 1. First animation block
    .append {
        state.offsetX = 10
        state.color = .red
    }
    // this animation is triggered but never awaited.
    // It's simply skipped from the sequence
    .async {
        state.scale = 1.5
    }
    // if another async animation is needed with different
    // animation values, simply add another async
    .async(duration: 0.4) {
        state.opacity = 0.5
    }
    // 2. This animation block will start right after number 1 is done.
    .append {
        state = AnimationState()
    }
    .start()
```

### Wait
Sometimes a small waiting time is needed, but we don't want to modify the next animation's delay, because that's annoying to be adding and subtracting small double values. For that, there is a `wait()` function that simply does the process I just explained.

```swift
AnimationSequence()
    .append {
        state.offsetX = 10
        state.color = .red
    }
    // using this function is better than appending
    // an empty animation block. wait() will add the delay
    // to the next block, instead of triggering a new animation
    .wait(for: 0.2)
    .append {
        state = AnimationState()
    }
    .start()
```

### Debug
To bring more transparency on what's going on with our animations, there is a `debug()` function that enables a flag to print whenever an animation is dispatched, the onFinish callback, and a few more details.

```swift
AnimationSequence()
    .debug()
    .start()
```

## To do
- Debug more animation details
- 

## Contribution

If you find the project interesting, catch any mistakes I've made, or just see room for improvement, feel free to fork and contribute, I'll be more than happy.
