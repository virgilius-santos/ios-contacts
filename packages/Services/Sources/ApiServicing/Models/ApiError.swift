import Foundation

public struct ApiError: Error, Equatable, Sendable {
    public let errorType: ApiErrorType
    public let context: ApiContext
    
    public init(
        errorType: ApiErrorType,
        context: ApiContext
    ) {
        self.errorType = errorType
        self.context = context
    }
}

#if DEBUG
extension ApiError {
    public static func fixture(
        errorType: ApiErrorType = .urlBuildingFailed,
        context: ApiContext = .fixture()
    ) -> Self {
        .init(
            errorType: errorType,
            context: context
        )
    }
}
#endif
