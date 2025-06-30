import XCTest
@testable import Interview
import ApiServicing

final class MockListContactServicing: ListContactServicing {
    enum Message: Equatable {
        case fetchContacts
    }

    private(set) var messages: [Message] = [] {
        didSet {
            anyMessages.appendLast(of: messages)
        }
    }
    
    public var anyMessages = AnyMessages()
    
    private(set) var completions: [(Result<[Contact], ApiError>) -> Void] = []
    func fetchContacts(completion: @escaping (Result<[Contact], ApiError>) -> Void) {
        messages.append(.fetchContacts)
        completions.append(completion)
    }
    func simulateResponse(
        at index: Int = 0,
        with result: Result<[Contact], ApiError>
    ) {
        completions[index](result)
    }
}
