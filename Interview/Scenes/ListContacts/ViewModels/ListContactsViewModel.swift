import Foundation
import ApiService
import ApiServicing

final class ListContactsViewModel {
    private let service: ListContactServicing
    
    init() {
        service = ListContactService(apiService: ApiService(urlBase: "https://669ff1b9b132e2c136ffa741.mockapi.io/").mainThreadSafe)
    }
    
    func loadContacts(_ completion: @escaping ([Contact]?, Error?) -> Void) {
        service.fetchContacts { result in
            switch result {
            case .success(let success):
                completion(success, nil)
            case .failure(let failure):
                completion(nil, failure)
            }
        }
    }
}
