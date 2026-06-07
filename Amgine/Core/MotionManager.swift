import CoreMotion

/// Thin CoreMotion wrapper exposing the device's gravity vector.
///
/// `verticalGravity` is gravity projected onto the device's vertical (y) axis:
///   • about -1 when the phone is held upright (top of the phone pointing up)
///   • about +1 when the phone is flipped 180° (top pointing at the floor)
///
/// Raw device-motion / accelerometer access requires no privacy usage string
/// (unlike CMMotionActivity / pedometer APIs), so no Info.plist key is needed.
@MainActor
@Observable
final class MotionManager {
    private let manager = CMMotionManager()

    private(set) var verticalGravity: Double = -1.0
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
        }
    }

    func stop() {
        manager.stopDeviceMotionUpdates()
    }
}
