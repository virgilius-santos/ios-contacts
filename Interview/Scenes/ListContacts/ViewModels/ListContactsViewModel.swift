import Foundation
import ApiService
import ApiServicing

final class UserIdsLegacy {
    var legacyIds = [10, 11, 12, 13]
    
    func isLegacy(id: Int) -> Bool {
        legacyIds.contains(id)
    }
}

struct ContactViewModel: Equatable {
    let name: String
    let imageURL: URL
}

protocol ListContactsViewModeling {
    func loadContacts()
    func numberOfContacts() -> Int
    func contact(at index: Int) -> ContactViewModel?
    func didSelectedContact(at index: Int)
}

final class ListContactsViewModel {
    weak var displayLogic: ListContactsDisplayLogic?
    
    private let service: ListContactServicing
    private let userIdsLegacy = UserIdsLegacy()
    
    private var contacts = [Contact]()
    private var imageCache: [IndexPath: Data] = [:]
    private var pendingRequests: [IndexPath: URLSessionDataTask] = [:]
    
    init(service: ListContactServicing) {
        self.service = service
    }
}

extension ListContactsViewModel: ListContactsViewModeling {
    func loadContacts() {
        displayLogic?.displayTitle("Lista de contatos")
        displayLogic?.startLoading()
        service.fetchContacts { [weak self] result in
            guard let self else { return }
            self.handle(result)
        }
    }
    
    private func handle(_ result: Result<[Contact], ApiError>) {
        switch result {
        case .success(let contacts):
            self.contacts = contacts
            displayLogic?.displayContacts()
        case .failure(let failure):
            displayLogic?.showMessage(
                title: "Ops, ocorreu um erro",
                message: failure.localizedDescription
            )
        }
        displayLogic?.stopLoading()
    }
    
    func numberOfContacts() -> Int {
        contacts.count
    }
    
    func contact(at index: Int) -> ContactViewModel? {
        guard let contact = contacts[safe: index] else { return nil }
        return ContactViewModel(
            name: contact.name,
            imageURL: contact.photoURL
        )
    }
    
    func didSelectedContact(at index: Int) {
        guard let contact = contacts[safe: index] else { return }
        guard userIdsLegacy.isLegacy(id: contact.id) else {
            displayLogic?.showMessage(title: "Você tocou em", message: contact.name)
            return
        }
        displayLogic?.showMessage(title: "Atenção", message: "Você tocou no contato sorteado")
        
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
