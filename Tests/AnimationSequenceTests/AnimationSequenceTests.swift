import XCTest
import AnimationSequence

final class AnimationSequenceTests: XCTestCase {
    func testAnimationSequence() {
        AnimationSequence()
            // verbose default true
            .verbose()
            // verbose set value
            .verbose(value: false)
            // base configuration default values
            .baseConfig()
            // base configuration set values
            .baseConfig(duration: 0.4, delay: 0.3, easing: .easeIn)
            // add sequential animation with default values
            .append {
                
            }
            // add sequential animation with specific values
            .append(duration: 0.4, delay: 0.2, easing: .linear) {
                
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
        XCTAssertEqual(AnimationConfiguration.defaultDelay, 0, "Default delay should be always 0")
        XCTAssertEqual(AnimationConfiguration.defaultDuration, 0.1, "Default delay should be 0.1")
    }
    
    func testDefaultEasing() {
        let defaultEasing = AnimationConfiguration.defaultEasing
        
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
