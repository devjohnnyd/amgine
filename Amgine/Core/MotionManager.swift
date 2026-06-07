import CoreMotion

/// Thin CoreMotion wrapper exposing the device's gravity vector and user acceleration.
///
/// Axis conventions:
///   verticalGravity  — gravity.y: -1 upright, +1 flipped 180°
///   flatGravity      — gravity.z: -1 face-up flat, +1 face-down flat
///   userAcceleration — device acceleration minus gravity (g units)
///
/// Raw device-motion access requires no privacy usage string.
@MainActor
@Observable
final class MotionManager {
    private let manager = CMMotionManager()

    private(set) var verticalGravity: Double = -1.0
    private(set) var flatGravity: Double = 0.0
    private(set) var userAccelX: Double = 0.0
    private(set) var userAccelY: Double = 0.0
    private(set) var userAccelMagnitude: Double = 0.0
    private(set) var isAvailable: Bool = false

    func start() {
        guard manager.isDeviceMotionAvailable else {
            isAvailable = false
            return
        }
        isAvailable = true
        manager.deviceMotionUpdateInterval = 1.0 / 30.0
        manager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let self, let motion else { return }
            self.verticalGravity = motion.gravity.y
            self.flatGravity = motion.gravity.z
            let a = motion.userAcceleration
            self.userAccelX = a.x
            self.userAccelY = a.y
            self.userAccelMagnitude = (a.x * a.x + a.y * a.y + a.z * a.z).squareRoot()
        }
    }

    func stop() {
        manager.stopDeviceMotionUpdates()
    }
}
