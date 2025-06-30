import XCTest
@testable import Interview
import ApiServicing

final class MockListContactsDisplayLogic: ListContactsDisplayLogic {
    enum Message: Equatable {
        case displayTitle(String)
        case displayContacts
        case showMessage(title: String, message: String)
        case startLoading
        case stopLoading
    }

    private(set) var messages: [Message] = [] {
        didSet {
            anyMessages.appendLast(of: messages)
        }
    }
    
    public var anyMessages = AnyMessages()

    func displayTitle(_ title: String) {
        messages.append(.displayTitle(title))
    }

    func displayContacts() {
        messages.append(.displayContacts)
    }

    func showMessage(title: String, message: String) {
        messages.append(.showMessage(title: title, message: message))
    }

    func startLoading() {
        messages.append(.startLoading)
    }

    func stopLoading() {
        messages.append(.stopLoading)
    }
}
