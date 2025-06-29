import Foundation

public struct ApiRequest: Equatable, Sendable {
    public let urlPath: String
    
    public init(urlString: String) {
        self.urlPath = urlString
    }
}

#if DEBUG
extension ApiRequest {
    public static func fixture(
        urlPath: String = ""
    ) -> Self {
        .init(urlString: urlPath)
    }
}
#endif
