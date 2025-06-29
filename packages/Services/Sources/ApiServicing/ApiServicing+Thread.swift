import Foundation

public extension ApiServicing {
    var mainThreadSafe: ApiServicing {
        ApiServicingThreadWrapper(servicing: self)
    }
}

final class ApiServicingThreadWrapper: ApiServicing {
    let queue: DispatchQueue
    let servicing: ApiServicing
    
    init(servicing: ApiServicing, queue: DispatchQueue = .main) {
        self.servicing = servicing
        self.queue = queue
    }
    
    func cancel() {
        queue.async { [weak self] in
            self?.servicing.cancel()
        }
    }
    
    func fetch(request: ApiRequest, completion: @escaping (Result<ApiResponse, ApiError>) -> Void) {
        servicing.fetch(request: request) { [weak self] result in
            self?.queue.async {
                guard self != nil else { return }
                completion(result)
            }
        }
    }
}
