import SwiftUI

// enum that maps the SwiftUI.Animation options
public enum AnimationEasing {
    case `default`
    case easeIn
    case easeOut
    case easeInOut
    case linear
    case spring(response: Double, dampingFraction: Double, blendDuration: Double)
    case interpolatingSpring(mass: Double, stiffness: Double, damping: Double, initialVelocity: Double)
}

// small convenient alias to avoid typing the closure signature everywhere
public typealias AnimationBlock = () -> Void

public class AnimationConfiguration {
    
    // MARK: - Default values
    
    public static let defaultDuration: Double = 0.1
    public static let defaultDelay: Double = 0
    public static let defaultEasing: AnimationEasing = .default
    
    // MARK: - Properties
    
    public var duration: Double
    public var delay: Double
    public var easing: AnimationEasing
    public var block: AnimationBlock?
    public var isAsync: Bool = false
    
    // MARK: - Life cycle
    
    public init(duration: Double, delay: Double, easing: AnimationEasing, block: AnimationBlock? = nil) {
        self.duration = duration
        self.delay = delay
        self.easing = easing
        self.block = block
    }
}

// MARK: - Internal methods

extension AnimationConfiguration {
    /// Maps the internal AnimationEasing into SwiftUI.Animation easing
    internal var easingFunction: Animation {
        switch easing {
        case .default:
            return Animation.default
        case .easeIn:
            return Animation.easeIn(duration: duration)
        case .easeOut:
            return Animation.easeOut(duration: duration)
        case .easeInOut:
            return Animation.easeInOut(duration: duration)
        case .linear:
            return Animation.linear(duration: duration)
        case .spring(let response, let dampingFraction, let blendDuration):
            return Animation.spring(
                response: response,
                dampingFraction: dampingFraction,
                blendDuration: blendDuration
            )
        case .interpolatingSpring(let mass, let stiffness, let damping, let initialVelocity):
            return Animation.interpolatingSpring(
                mass: mass,
                stiffness: stiffness,
                damping: damping,
                initialVelocity: initialVelocity
            )
        }
    }
}