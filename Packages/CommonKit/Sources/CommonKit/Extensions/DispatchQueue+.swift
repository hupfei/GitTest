import Foundation

public extension DispatchQueue {
    static func MainThread(execute work: @escaping @convention(block) () -> Void) {
        if Thread.isMainThread {
            work()
            return
        }

        DispatchQueue.main.async {
            work()
        }
    }
}
