import Testing
@testable import ApiService
import ApiServicing
import Foundation

extension URLResponse {
    static func fixture(
        statusCode: Int = 0
    ) -> HTTPURLResponse? {
        HTTPURLResponse(url: .fixture(), statusCode: statusCode, httpVersion: nil, headerFields: nil)
    }
}

extension ApiRequest {
    static let validRequest = ApiRequest.fixture(urlPath: "path")
}

extension String {
    static let urlStringFixture: String = "https://jsonplaceholder.typicode.com/"
}

extension URL {
    static func fixture(
        urlString: String = .urlStringFixture
    ) -> URL {
        .init(string: urlString) ?? URL(fileReferenceLiteralResourceName: urlString)
    }
}

func equal(
    _ messages: AnyMessages,
    _ expectedValue: [any Equatable],
    sourceLocation: SourceLocation = #_sourceLocation
) {
    let expectedMessages = AnyMessages(parameters: expectedValue.map({ .init($0) }))
    #expect(
        messages == expectedMessages,
        sourceLocation: sourceLocation
    )
}
