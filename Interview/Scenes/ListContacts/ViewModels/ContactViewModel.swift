import Foundation
import ApiServicing

protocol ContactViewModeling {
    var name: String { get }
    func loadImage(completion: @escaping (Data?) -> Void)
}

final class ContactViewModel: ContactViewModeling {
    var name: String { contact.name }
    
    let contact: Contact
    let imageService: ApiServicing
    
    init(contact: Contact, imageService: ApiServicing) {
        self.contact = contact
        self.imageService = imageService
    }
    
    func loadImage(completion: @escaping (Data?) -> Void) {
        imageService.fetch(request: .init(urlString: contact.photoURL.absoluteString)) { result in
            completion(try? result.get().data)
        }
    }
}
