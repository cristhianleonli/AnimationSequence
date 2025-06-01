import SwiftUI

public class AnimationSequence {
    
    // MARK: - Type aliases
    
    public typealias Easing = AnimationEasing
    public typealias Block = AnimationBlock
    
    // MARK: - Properties
    
    private var animations: [AnimationConfiguration] = []
    private var finishCallback: Block?
    private var defaultConfiguration: AnimationConfiguration?
    private var verbose: Bool = false
    private var currentID: Int = 0
    
    // MARK: Life cycle
    
    public init(
        duration: Double = AnimationDefaults.defaultDuration,
        delay: Double = AnimationDefaults.defaultDelay,
        easing: Easing = AnimationDefaults.defaultEasing
    ) {
        self.defaultConfiguration = AnimationConfiguration(
            label: "default",
            delay: delay,
            duration: duration,
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
    /// When an animation is async, means, it won't be awaited, this animation
    /// duration is not accumulated, hence ignored in the overall sequence. Its
    /// values are skept and won't affect the behavior of the other animations.
    ///
    /// Once the whole sequence is finished, the `onFinishCallback`, if provided,
    /// is called. Async animations are not part of the sequence timing.
    func start() {
        var offsetTime: Double = 0
        
        for config in animations {
            // creates the respective function given the duration
            let animation = config.easingFunction
            
            if self.verbose {
                print("Enqueued:", config)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + offsetTime + config.delay) {
                if self.verbose {
                    print("Dispatched: ", config)
                }
                
                withAnimation(animation) {
                    config.animation?()
                }
            }
            
            if !config.isAsync {
                offsetTime += config.duration
                offsetTime += config.delay
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + offsetTime) {
            if self.verbose {
                print("Animation sequence finished")
            }
            
            self.finishCallback?()
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
    func commonConfig(
        delay: Double = AnimationDefaults.defaultDelay,
        duration: Double = AnimationDefaults.defaultDuration,
        easing: Easing = AnimationDefaults.defaultEasing
    ) -> AnimationSequence {
        defaultConfiguration = AnimationConfiguration(
            label: "default",
            delay: delay,
            duration: duration,
            easing: easing
        )
        
        return self
    }
    
    /// Adds an animation that will be trigger sequentially
    /// - Parameters:
    ///   - label: String to identify the animation
    ///   - delay: Double animation delay. Default `0.0`
    ///   - duration: Double animation duration. Default `0.1`
    ///   - easing: AnimationEasing. Default `default`
    ///   - animation: The actions to be executed when the animation is dispatched
    /// - Returns: self instance
    @discardableResult
    func add(
        label: String? = nil,
        delay: Double? = nil,
        duration: Double? = nil,
        easing: Easing? = nil,
        animation closure: @escaping Block
    ) -> AnimationSequence {
        let animation = AnimationConfiguration(
            label: getLabel(value: label),
            delay: getDelay(value: delay),
            duration: getDuration(value: duration),
            easing: getEasing(value: easing),
            animation: closure,
            isAsync: false
        )
        
        animations.append(animation)
        return self
    }
    
    /// Adds a animation that will be triggered asynchronously and will not be awaited
    /// - Parameters:
    ///   - label: String to identify the animation
    ///   - delay: Double animation delay. Default `0.0`
    ///   - duration: Double animation duration. Default `0.1`
    ///   - easing: AnimationEasing. Default `default`
    ///   - animation: The actions to be executed when the animation is dispatched
    /// - Returns: self instance
    @discardableResult
    func async(
        label: String? = nil,
        delay: Double? = nil,
        duration: Double? = nil,
        easing: Easing? = nil,
        animation: @escaping Block
    ) -> AnimationSequence {
        let animation = AnimationConfiguration(
            label: getLabel(value: label),
            delay: getDelay(value: delay),
            duration: getDuration(value: duration),
            easing: getEasing(value: easing),
            animation: animation,
            isAsync: true
        )
        
        animations.append(animation)
        return self
    }
    
    /// Adds the value as delay to the last non-async animation
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
    
    /// Enables the debug mode, which will print when animations are enqueued, and dispatched
    /// - Parameter value: Boolean with the value to be set
    /// - Returns: self instance
    @discardableResult
    func debug() -> AnimationSequence {
        self.verbose = true
        return self
    }
    
    /// Adds a callback to the animation sequence
    /// - Parameter callback: () -> Void block
    /// - Returns: self instance
    @discardableResult
    func onFinish(callback: @escaping Block) -> AnimationSequence {
        self.finishCallback = callback
        return self
    }
}

// MARK: - Private functions

private extension AnimationSequence {
    /// Defaults the given duration to base configuration or AnimationConfiguration otherwise
    /// - Parameter value: Double with duration
    /// - Returns: Calculated default duration
    func getDuration(value: Double?) -> Double {
        return value ?? defaultConfiguration?.duration ?? AnimationDefaults.defaultDuration
    }
    
    /// Defaults the given delay to base configuration or AnimationConfiguration otherwise
    /// - Parameter value: Double with delay
    /// - Returns: Calculated default delay
    func getDelay(value: Double?) -> Double {
        return value ?? defaultConfiguration?.delay ?? AnimationDefaults.defaultDelay
    }
    
    /// Defaults the given easing to base configuration or AnimationConfiguration otherwise.
    /// - Parameter value: AnimationEasing
    /// - Returns: Calculated default easing
    func getEasing(value: Easing?) -> Easing {
        return value ?? defaultConfiguration?.easing ?? AnimationDefaults.defaultEasing
    }
    
    func getLabel(value: String?) -> String {
        defer { currentID += 1 }
        return value ?? "\(currentID)"
    }
}
