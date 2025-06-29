import Foundation

public struct ApiContext: Equatable, Sendable {
    public let request: ApiRequest
    public let data: Data?
    public let urlResponse: URLResponse?
    public let error: NSError?
    
    public init(
        request: ApiRequest,
        data: Data? = nil,
        urlResponse: URLResponse? = nil,
        error: NSError? = nil
    ) {
        self.request = request
        self.data = data
        self.urlResponse = urlResponse
        self.error = error
    }
}

#if DEBUG
extension ApiContext {
    public static func fixture(
        request: ApiRequest = .fixture(),
        data: Data? = nil,
        urlResponse: URLResponse? = nil,
        error: NSError? = nil
    ) -> Self {
        .init(
            request: request,
            data: data,
            urlResponse: urlResponse,
            error: error
        )
    }
}
#endif
