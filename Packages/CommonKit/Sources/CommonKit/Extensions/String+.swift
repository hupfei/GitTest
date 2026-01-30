import Foundation

public extension String {
    /// 字符串非空
    var nonEmpty: Bool {
        return !isEmpty
    }
}

public extension Optional where Wrapped == String {
    /// 字符串为空
    var isEmpty: Bool {
        guard let ss = self else { return true }
        return ss.isEmpty
    }

    /// 字符串非空
    var nonEmpty: Bool {
        guard let ss = self else { return false }
        return ss.nonEmpty
    }
}
