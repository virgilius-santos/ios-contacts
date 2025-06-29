import Foundation

public extension ApiServicing {
    func cached() -> ApiServicing {
        ApiServicingCache(servicing: self)
    }
}

final class ApiServicingCache: ApiServicing {
    let store: ApiStorage
    let servicing: ApiServicing
    
    init(servicing: ApiServicing, store: ApiStorage = .default) {
        self.store = store
        self.servicing = servicing
    }
    
    func cancel() {
        servicing.cancel()
    }
    
    func fetch(request: ApiRequest, completion: @escaping (Result<ApiResponse, ApiError>) -> Void) {
        if let response = store.get(request) {
            completion(.success(response))
            return
        }
        servicing.fetch(request: request) { [weak self] result in
            guard let self else { return }
            if case .success(let response) = result {
                self.store.set(request, response: response)
            }
            completion(result)
        }
    }
}
