import Foundation

public struct ApiResponse: Equatable, Sendable {
    public let data: Data
    public let context: ApiContext
    
    public init(data: Data, context: ApiContext) {
        self.data = data
        self.context = context
    }
}

#if DEBUG
extension ApiResponse {
    public static func fixture(
        data: Data = Data(),
        context: ApiContext = .fixture()
    ) -> Self {
        .init(
            data: data,
            context: context
        )
    }
}
#endif
