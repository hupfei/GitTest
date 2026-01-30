import Foundation

public extension Optional where Wrapped == Bool {
    var unwrappedBoolValue: Bool {
        guard let ss = self else { return false }
        return ss
    }
}
