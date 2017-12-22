import Foundation

struct Util {
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
}
