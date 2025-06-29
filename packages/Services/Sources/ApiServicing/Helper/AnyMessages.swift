import Foundation

public final class AnyMessages: Equatable, CustomStringConvertible {
    public static func == (lhs: AnyMessages, rhs: AnyMessages) -> Bool {
        lhs.parameters == rhs.parameters
    }
    
    public var description: String {
        if parameters.isEmpty {
            return ""
        } else {
            let params = parameters.map { "\($0.base)" }.joined(separator: ", ")
            return params
        }
    }
    
    private(set) var parameters: [AnyEquatable]

    public init(parameters: [AnyEquatable] = []) {
        self.parameters = parameters
    }
    
    public func appendLast(of array: [any Equatable]) {
        guard let last = array.last else { return }
        parameters.append(.init(last))
    }
    
    public func clearMessages() {
        parameters = []
    }
}
