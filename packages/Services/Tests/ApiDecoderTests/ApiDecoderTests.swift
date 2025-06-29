import Testing
@testable import ApiDecoder
import ApiServicing
import Foundation

extension ApiDecoderTests {
    typealias Sut = ApiServicing
    
    final class Doubles {
        var anyMessages = AnyMessages()
        let apiMock = MockApiServicing()
    }
    
    func makeSut(urlBase: String? = nil) -> (Sut, Doubles) {
        let doubles = Doubles()
        let sut = doubles.apiMock
        doubles.apiMock.anyMessages = doubles.anyMessages
        return (sut, doubles)
    }
}

struct ApiDecoderTests {
    @Test
    func fetchDecoded_whenFetchSucceeds_shouldReturnDecodedResponse() {
        let (sut, doubles) = makeSut()
        let apiResponseSent = ApiResponse.fixture(data: jsonData)
        
        sut.fetchDecoded(request: .fixture(), returning: Contact.self) { [weak doubles] result in
            doubles?.anyMessages.appendLast(of: [result])
        }
             
        equal(doubles.anyMessages, [
            MockApiServicing.Message.fetch(request: .fixture())
        ])
        
        doubles.apiMock.simulateFetchResponse(with: .success(apiResponseSent))
        
        equal(doubles.anyMessages, [
            MockApiServicing.Message.fetch(request: .fixture()),
            Result<ApiDecoderResponse<Contact>, ApiError>.success(.init(
                decoded: .fixture(),
                response: apiResponseSent
            ))
        ])
    }
    
    @Test
    func fetchDecoded_whenFetchFails_shouldReturnFailure() {
        let (sut, doubles) = makeSut()
        
        sut.fetchDecoded(request: .fixture(), returning: Contact.self) { [weak doubles] result in
            doubles?.anyMessages.appendLast(of: [result])
        }
             
        equal(doubles.anyMessages, [
            MockApiServicing.Message.fetch(request: .fixture())
        ])
        
        doubles.apiMock.simulateFetchResponse(with: .failure(.fixture()))
        
        equal(doubles.anyMessages, [
            MockApiServicing.Message.fetch(request: .fixture()),
            Result<ApiDecoderResponse<Contact>, ApiError>.failure(.fixture())
        ])
    }
}

let jsonData = #"""
{
    "id": 1,
    "name": "Shakira",
    "photoURL": "https://picsum.photos/id/237/200/"
}
"""#.data(using: .utf8) ?? .init()

struct Contact: Decodable, Equatable {
    let id: Int
    let name: String
    let photoURL: URL
    
    static func fixture(
        id: Int = 1,
        name: String = "Shakira",
        photoURL: URL = .init(string: "https://picsum.photos/id/237/200/")!
    ) -> Self {
        .init(
            id: id,
            name: name,
            photoURL: photoURL
        )
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
