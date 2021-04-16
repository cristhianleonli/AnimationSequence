import XCTest
import SwiftUI
import AnimationSequence

final class AnimationSequenceTests: XCTestCase {
    func testAnimationSequence() {
        AnimationSequence()
            // verbose default true
            .debug()
            // base configuration default values
            .commonConfig()
            // base configuration set values
            .commonConfig(duration: 0.4, delay: 0.3, easing: .easeIn)
            // add sequential animation with default values
            .append {
            }
            // add sequential animation with specific values
            .append(duration: 0.4, delay: 0.2, easing: .linear) {
            }
            // add sequential animation with custom SwiftUI.animation
            .append(easing: .custom(animation: Animation.spring(response: 1, dampingFraction: 0.80, blendDuration: 0.6))) {
            }
            // add async animation with default values
            .async {
            }
            // add async animation with specific values
            .async(duration: 0.3, delay: 0.2, easing: .easeIn) {
            }
            // sleep
            .wait(for: 5)
            .start()
    }
    
    func testConstants() {
        XCTAssertEqual(AnimationDefaults.defaultDelay, 0, "Default delay should be always 0")
        XCTAssertEqual(AnimationDefaults.defaultDuration, 0.1, "Default delay should be 0.1")
    }
    
    func testDefaultEasing() {
        let defaultEasing = AnimationDefaults.defaultEasing
        
        switch defaultEasing {
        case .default:
            break
        default:
            XCTFail("Default easing should be .default")
        }
    }
    
    func testConfigurationInit() {
        // Given
        let duration: Double = 0.5
        let delay: Double = 0.2
        
        // When
        let config = AnimationConfiguration(duration: duration, delay: delay, easing: .easeIn)
        
        // Then
        XCTAssertEqual(config.duration, duration, "Duration should be \(duration)")
        XCTAssertEqual(config.delay, delay, "Delay should be \(delay)")
        
        switch config.easing {
        case .easeIn:
            break
        default:
            XCTFail("Easing should be .easeIn")
        }
    }

    static var allTests = [
        ("testAnimationSequence", testAnimationSequence),
        ("testConfigurationInit", testConfigurationInit),
        ("testDefaultEasing", testDefaultEasing),
        ("testConstants", testConstants),
    ]
}
