import Foundation

public protocol HasApply: AnyObject { }

public extension HasApply {
    @discardableResult
    @inline(__always)
    func apply(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

extension NSObject: HasApply { }
