import Foundation

public protocol ApiServicing {
    func fetch(request: ApiRequest, completion: @escaping (Result<ApiResponse, ApiError>) -> Void)
    func cancel()
}

#if DEBUG
public final class MockApiServicing: ApiServicing {
    public init() {}
    
    public enum Message: Equatable {
        case fetch(request: ApiRequest)
        case cancel
    }
    
    public var messages: [Message] = []
    
    public private(set) var fetchCompletions: [(Result<ApiResponse, ApiError>) -> Void] = []
    public func fetch(request: ApiRequest, completion: @escaping (Result<ApiResponse, ApiError>) -> Void) {
        messages.append(.fetch(request: request))
        fetchCompletions.append(completion)
    }
    public func simulateFetchResponse(at index: Int = 0, with response: Result<ApiResponse, ApiError>) {
        fetchCompletions[index](response)
    }
    
    public func cancel() {
        messages.append(.cancel)
    }
}
#endif
