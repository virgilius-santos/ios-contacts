import Foundation

protocol SessionProtocol {
    func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> SessionTaskProtocol
}

protocol SessionTaskProtocol {
    func resume()
    func cancel()
}

#if DEBUG
public final class MockSessionTask: SessionTaskProtocol {
    public init() {}
    
    public enum Message: Equatable {
        case resume
        case cancel
    }

    public private(set) var messages: [Message] = []

    public func resume() {
        messages.append(.resume)
    }
    
    public func cancel() {
        messages.append(.cancel)
    }
}

final class MockSession: SessionProtocol {
    public enum Message: Equatable {
        case dataTask(request: URL)
    }

    public private(set) var messages: [Message] = []

    public var task: MockSessionTask = .init()
    
    public private(set) var completions: [(Data?, URLResponse?, Error?) -> Void] = []
    public func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> SessionTaskProtocol {
        messages.append(.dataTask(request: url))
        completions.append(completionHandler)
        return task
    }
    public func simulateResponse(
        at index: Int = 0,
        data: Data? = nil,
        response: URLResponse? = nil,
        error: Error? = nil
    ) {
        completions[index](data, response, error)
    }
}
#endif
