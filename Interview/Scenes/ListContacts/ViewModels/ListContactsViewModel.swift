import Foundation
import ApiService
import ApiServicing

struct UserIdsLegacy {
    var legacyIds: [Int] = [10, 11, 12, 13]
    
    func isLegacy(id: Int) -> Bool {
        legacyIds.contains(id)
    }
}

protocol ListContactsViewModeling {
    func loadContacts()
    func numberOfContacts() -> Int
    func contact(at index: Int) -> ContactViewModeling?
    func didSelectedContact(at index: Int)
}

final class ListContactsViewModel {
    typealias Dependencies = HasImageService
    
    weak var displayLogic: ListContactsDisplayLogic?
    
    private let dependencies: Dependencies
    private let service: ListContactServicing
    private let userIdsLegacy: UserIdsLegacy
    
    private var contacts = [ContactViewModel]()
    
    init(dependencies: Dependencies, service: ListContactServicing, userIdsLegacy: UserIdsLegacy = .init()) {
        self.dependencies = dependencies
        self.service = service
        self.userIdsLegacy = userIdsLegacy
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
            self.contacts = contacts.map(mapContact(_:))
            displayLogic?.displayContacts()
        case .failure(let failure):
            displayLogic?.showMessage(
                title: "Ops, ocorreu um erro",
                message: failure.localizedDescription
            )
        }
        displayLogic?.stopLoading()
    }
    
    private func mapContact(_ contact: Contact) -> ContactViewModel {
        .init(contact: contact, imageService: dependencies.imageService)
    }
    
    func numberOfContacts() -> Int {
        contacts.count
    }
    
    func contact(at index: Int) -> ContactViewModeling? {
        contacts[safe: index]
    }
    
    func didSelectedContact(at index: Int) {
        guard let contact = contacts[safe: index]?.contact else { return }
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
