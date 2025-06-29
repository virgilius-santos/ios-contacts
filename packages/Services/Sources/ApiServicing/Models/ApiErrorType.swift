import Foundation

public enum ApiErrorType: Error, Equatable {
    case urlBuildingFailed
    case requestError
    case invalidResponse
    case invalidaData
    case decodeError(NSError)
}

#if DEBUG
extension ApiErrorType {
    public static func fixture(
        type: ApiErrorType = .urlBuildingFailed
    ) -> Self {
        type
    }
}

extension NSError {
    public static func fixture() -> NSError {
        ApiErrorType.fixture() as NSError
    }
}
#endif
