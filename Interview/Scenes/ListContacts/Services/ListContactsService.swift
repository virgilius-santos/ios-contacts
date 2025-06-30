import Foundation
import ApiServicing
import ApiDecoder

protocol ListContactServicing {
    func fetchContacts(completion: @escaping (Result<[Contact], ApiError>) -> Void)
}

final class ListContactService: ListContactServicing {
    typealias Dependencies = HasApiService
    
    let apiService: ApiServicing
    
    init(dependencies: Dependencies) {
        self.apiService = dependencies.apiService
    }
    
    func fetchContacts(completion: @escaping (Result<[Contact], ApiError>) -> Void) {
        let request = ApiRequest(urlString: "picpay/ios/interview/contacts")
        apiService.fetchDecoded(request: request, returning: [Contact].self) { [weak self] result in
            guard self != nil else { return }
            completion(result.map(\.decoded))
        }
    }
}
