import XCTest
@testable import Interview
import ApiServicing

final class ListContactViewModelTests: XCTestCase {
    typealias Sut = ListContactsViewModel
    
    final class Doubles {
        let dependenciesMock = MockDependenciesContainer()
        let serviceMock = MockListContactServicing()
        let displayLogicMock = MockListContactsDisplayLogic()
        let userIdsLegacyMock = UserIdsLegacy(legacyIds: [0])
        var anyMessages = AnyMessages()
    }
    
    func makeSut() -> (Sut, Doubles) {
        let doubles = Doubles()
        let sut = Sut(
            dependencies: doubles.dependenciesMock,
            service: doubles.serviceMock,
            userIdsLegacy: doubles.userIdsLegacyMock
        )
        sut.displayLogic = doubles.displayLogicMock
        
        doubles.serviceMock.anyMessages = doubles.anyMessages
        doubles.displayLogicMock.anyMessages = doubles.anyMessages
        
        return (sut, doubles)
    }
}

extension ListContactViewModelTests {
    func test_loadContacts_shouldStartLoadingAndFetch() {
        let (sut, doubles) = makeSut()
        
        assertLoadContactsStarted(sut, doubles)
    }
    
    func test_loadContacts_whenFetchSucceeds_shouldDisplayContacts() {
        let (sut, doubles) = makeSut()
        
        assertLoadContactsCompletedSuccessfully(sut, doubles)
    }
    
    func test_numberOfContacts_afterSuccessfulLoad_shouldReturnCorrectCount() {
        let (sut, doubles) = makeSut()
        assertLoadContactsCompletedSuccessfully(sut, doubles)
        
        let result = sut.numberOfContacts()
        
        XCTAssertEqual(result, 2)
    }
    
    func test_contactAtIndex_afterSuccessfulLoad_shouldReturnCorrectContact() {
        let (sut, doubles) = makeSut()
        assertLoadContactsCompletedSuccessfully(sut, doubles)
        
        let result = sut.contact(at: 1)
        
        XCTAssertEqual(result?.name, "name")
    }
    
    func test_didSelectContact_atIndexZero_shouldShowAttentionMessage() {
        let (sut, doubles) = makeSut()
        assertLoadContactsCompletedSuccessfully(sut, doubles)
        
        sut.didSelectedContact(at: 0)
        
        assertMessages(doubles.anyMessages, [
            MockListContactsDisplayLogic.Message.showMessage(title: "Atenção", message: "Você tocou no contato sorteado")
        ])
    }
    
    func test_didSelectContact_atIndexOne_shouldShowNameMessage() {
        let (sut, doubles) = makeSut()
        assertLoadContactsCompletedSuccessfully(sut, doubles)
        
        sut.didSelectedContact(at: 1)
        
        assertMessages(doubles.anyMessages, [
            MockListContactsDisplayLogic.Message.showMessage(title: "Você tocou em", message: "name")
        ])
    }
    
    func test_loadContacts_whenFetchFails_shouldShowErrorMessageAndStopLoading() {
        let (sut, doubles) = makeSut()
        
        assertLoadContactsStarted(sut, doubles)
        
        doubles.serviceMock.simulateResponse(with: .failure(.fixture()))
        
        assertMessages(doubles.anyMessages, [
            MockListContactsDisplayLogic.Message.showMessage(title: "Ops, ocorreu um erro", message: "The operation couldn’t be completed. (ApiServicing.ApiError error 1.)"),
            MockListContactsDisplayLogic.Message.stopLoading
        ])
    }
    
    func assertLoadContactsStarted(
        _ sut: Sut,
        _ doubles: Doubles,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        sut.loadContacts()
        
        assertMessages(doubles.anyMessages, [
            MockListContactsDisplayLogic.Message.displayTitle("Lista de contatos"),
            MockListContactsDisplayLogic.Message.startLoading,
            MockListContactServicing.Message.fetchContacts
        ], file: file, line: line)
        
        doubles.anyMessages.clearMessages()
    }
    
    func assertLoadContactsCompletedSuccessfully(
        _ sut: Sut,
        _ doubles: Doubles,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        assertLoadContactsStarted(sut, doubles)
        
        doubles.serviceMock.simulateResponse(with: .success([
            .fixture(id: 0), .fixture(id: 1, name: "name")
        ]))
        
        assertMessages(doubles.anyMessages, [
            MockListContactsDisplayLogic.Message.displayContacts,
            MockListContactsDisplayLogic.Message.stopLoading
        ])
        
        doubles.anyMessages.clearMessages()
    }
}

extension Contact {
    static func fixture(
        id: Int = 0,
        name: String = "",
        photoURL: URL = URL(string: "https://example.com/photo.jpg")!
    ) -> Self {
        .init(
            id: id,
            name: name,
            photoURL: photoURL
        )
    }
}
