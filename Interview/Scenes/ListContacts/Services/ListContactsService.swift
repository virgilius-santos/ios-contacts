import Foundation
import ApiServicing
import ApiDecoder

private let apiURL = "https://669ff1b9b132e2c136ffa741.mockapi.io/picpay/ios/interview/contacts"

protocol ListContactServicing {
    func fetchContacts(completion: @escaping (Result<[Contact], ApiError>) -> Void)
}

final class ListContactService: ListContactServicing {
    let apiService: ApiServicing
    
    init(apiService: ApiServicing) {
        self.apiService = apiService
    }
    
    func fetchContacts(completion: @escaping (Result<[Contact], ApiError>) -> Void) {
        let request = ApiRequest(urlString: "picpay/ios/interview/contacts")
        apiService.fetchDecoded(request: request, returning: [Contact].self) { [weak self] result in
            guard self != nil else { return }
            completion(result.map(\.decoded))
        }
    }
}
