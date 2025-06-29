import ApiServicing
import Foundation

public struct ApiDecoderResponse<T: Decodable> {
    public let decoded: T
    public let response: ApiResponse
}

extension ApiDecoderResponse: Equatable where T: Equatable {}
