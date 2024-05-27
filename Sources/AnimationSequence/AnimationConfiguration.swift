import SwiftUI

// enum that maps the SwiftUI.Animation options
public enum AnimationEasing {
    case `default`
    case easeIn
    case easeOut
    case easeInOut
    case linear
    case custom(animation: Animation)
}

// Used to provide animation blocks, and any type of callback
public typealias AnimationBlock = () -> Void

// MARK: - Default values

public struct AnimationDefaults {
    public static let defaultDelay: Double = 0
    public static let defaultDuration: Double = 0.1
    public static let defaultEasing: AnimationEasing = .default
}

public class AnimationConfiguration: CustomStringConvertible {
    
    // MARK: - Properties
    
    public var label: String
    public var delay: Double
    public var duration: Double
    public var easing: AnimationEasing
    public var animation: AnimationBlock?
    public var isAsync: Bool
    
    // MARK: - Life cycle
    
    public init(
        label: String,
        delay: Double,
        duration: Double,
        easing: AnimationEasing, 
        animation: AnimationBlock? = nil,
        isAsync: Bool = false
    ) {
        self.label = label
        self.delay = delay
        self.duration = duration
        self.easing = easing
        self.animation = animation
        self.isAsync = isAsync
    }
    
    public var description: String {
        return [
            "[label: \(label)",
            "delay: \(delay)",
            "duration: \(duration)",
            "easing: \(easing)",
            "isAsync: \(isAsync)]"
        ].joined(separator: "\t")
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
        case .custom(let animation):
            return animation
        }
    }
}
