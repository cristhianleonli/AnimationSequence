import SwiftUI

public class AnimationSequence {
    
    // MARK: - Type aliases
    
    public typealias Easing = AnimationEasing
    public typealias Block = AnimationBlock
    
    // MARK: - Properties
    
    private var animations: [AnimationConfiguration] = []
    private var callback: Block?
    private var defaultConfiguration: AnimationConfiguration?
    private var verbose: Bool = false
    
    // MARK: Life cycle
    
    public init(duration: Double = AnimationDefaults.defaultDuration,
                delay: Double = AnimationDefaults.defaultDelay,
                easing: Easing = AnimationDefaults.defaultEasing) {
        self.defaultConfiguration = AnimationConfiguration(
            duration: duration,
            delay: delay,
            easing: easing
        )
    }
}

// MARK: - Public methods

public extension AnimationSequence {
    /// Iterates over the animations array, and accumulates the duration + delay
    /// of each, so that the timeline keeps the order and animations are
    /// executed properly. After all animations are triggered, one last
    /// dispatch from the main queue will execute the onFinish callback.
    ///
    /// When an animation is async, meaning, it won't be awaited, this animation
    /// duration is not accumulated, hence ignored in the sequence. Basically its
    /// values gets skep and won't affect the behaviour of the other animations.
    func start() {
        var offsetTime: Double = 0
        
        for config in animations {
            // creates the respective function given the duration
            let animation = config.easingFunction
            
            // set the offset for when the next animation should start at
            offsetTime += config.delay
            
            // executes the animation with the predefined offset
            withAnimation(animation.delay(offsetTime)) {
                // animate the "block" with the given animation parameters
                if self.verbose {
                    print(animation)
                }
                
                config.block?()
            }
            
            if !config.isAsync {
                offsetTime += config.duration
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + offsetTime) {
            if self.verbose {
                print("Animation sequence has finished")
            }
            
            self.callback?()
        }
    }
    
    /// Sets the given values as default for all animations in the sequence.
    /// If an animation has different values, this configuration will have no effect
    /// - Parameters:
    ///   - duration: Default duration for all animation in the sequence
    ///   - delay: Default delay for all animation in the sequence
    ///   - easing: Default easing function for all animation in the sequence
    /// - Returns: self instance
    @discardableResult
    func commonConfig(duration: Double = AnimationDefaults.defaultDuration,
                    delay: Double = AnimationDefaults.defaultDelay,
                    easing: Easing = AnimationDefaults.defaultEasing) -> AnimationSequence {
        defaultConfiguration = AnimationConfiguration(
            duration: duration,
            delay: delay,
            easing: easing
        )
        
        return self
    }
    
    /// Adds an animation that will be trigger sequentially
    /// - Parameters:
    ///   - duration: Double animation duration, if nil, default duration will be set
    ///   - delay: Double animation delay, if nil, default delay will be set
    ///   - easing: AnimationEasing, if nil, .default will be set
    ///   - closure: The actions to be executed when the animation is dispatched
    /// - Returns: self instance
    @discardableResult
    func append(duration: Double? = nil, delay: Double? = nil, easing: Easing? = nil, closure: @escaping Block) -> AnimationSequence {
        let animation = AnimationConfiguration(
            duration: lastDuration(value: duration),
            delay: lastDelay(value: delay),
            easing: lastEasing(value: easing),
            block: closure
        )
        
        animations.append(animation)
        return self
    }
    
    /// Adds a animation that will be triggered asynchronously and will not be awaited
    /// - Parameters:
    ///   - duration: Double animation duration, if nil, default duration will be set
    ///   - delay: Double animation delay, if nil, default delay will be set
    ///   - easing: AnimationEasing, if nil, .default will be set
    ///   - closure: The actions to be executed when the animation is dispatched
    /// - Returns: self instance
    @discardableResult
    func async(duration: Double? = nil, delay: Double? = nil, easing: Easing? = nil, closure: @escaping Block) -> AnimationSequence {
        let animation = AnimationConfiguration(
            duration: lastDuration(value: duration),
            delay: lastDelay(value: delay),
            easing: lastEasing(value: easing),
            block: closure
        )
        
        animation.isAsync = true
        
        animations.append(animation)
        return self
    }
    
    /// Adds the seconds value as delay to the last non-async animation
    /// - Parameter seconds: Double with the waiting time
    /// - Returns: self instance
    @discardableResult
    func wait(for seconds: Double) -> AnimationSequence {
        // Look for the very last sync animation and add the waiting seconds to the
        // delay, that produces the same effect as creating an empty animation
        // except that delay is more precise than dispatching a blank animation
        if let lastSyncIndex = animations.lastIndex(where: { $0.isAsync == false }) {
            animations[lastSyncIndex].delay += seconds
        }
        
        return self
    }
    
    /// Enables the debug mode, which will print when animations are executed
    /// - Parameter value: Boolean with the value to be set
    /// - Returns: self instance
    @discardableResult
    func debug() -> AnimationSequence {
        self.verbose = true
        return self
    }
    
    /// Add a callback to the animation sequence
    /// - Parameter closure: () -> Void block
    /// - Returns: self instance
    @discardableResult
    func onFinish(closure: @escaping Block) -> AnimationSequence {
        self.callback = closure
        return self
    }
}

// MARK: - Private functions

private extension AnimationSequence {
    /// Defaults the given duration to base configuration or AnimationConfiguration otherwise.
    /// - Parameter value: Double with duration
    /// - Returns: Calculated default duration
    func lastDuration(value: Double?) -> Double {
        return value ?? defaultConfiguration?.duration ?? AnimationDefaults.defaultDuration
    }
    
    /// Defaults the given delay to base configuration or AnimationConfiguration otherwise.
    /// - Parameter value: Double with delay
    /// - Returns: Calculated default delay
    func lastDelay(value: Double?) -> Double {
        return value ?? defaultConfiguration?.delay ?? AnimationDefaults.defaultDelay
    }
    
    /// Defaults the given easing to base configuration or AnimationConfiguration otherwise.
    /// - Parameter value: AnimationEasing
    /// - Returns: Calculated default easing
    func lastEasing(value: Easing?) -> Easing {
        return value ?? defaultConfiguration?.easing ?? AnimationDefaults.defaultEasing
    }
}
