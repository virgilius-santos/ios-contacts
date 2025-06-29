import Foundation
import ApiServicing

public final class ApiService {
    let urlBase: String
    let session: SessionProtocol
    private var task: SessionTaskProtocol? {
        willSet {
            task?.cancel()
        }
    }
    
    public convenience init(urlBase: String) {
        self.init(urlBase: urlBase, session: URLSession.shared)
    }
    
    init(urlBase: String, session: SessionProtocol) {
        self.urlBase = urlBase
        self.session = session
    }
}

extension ApiService: ApiServicing {
    public func fetch(
        request: ApiRequest,
        completion: @escaping (Result<ApiResponse, ApiError>) -> Void
    ) {
        guard let api = URL(string: urlBase + request.urlPath) else {
            completion(.failure(.init(errorType: .urlBuildingFailed, context: .init(request: request))))
            return
        }
        
        task = session.dataTask(with: api) { [weak self] (data, response, error) in
            guard let self else { return }
            let context = ApiContext(
                request: request,
                data: data,
                urlResponse: response,
                error: error as NSError?
            )
            self.handleResponse(
                context: context,
                completion: completion
            )
        }
        
        task?.resume()
    }
    
    public func cancel() {
        task?.cancel()
    }
}

private extension ApiService {
    func handleResponse(
        context: ApiContext,
        completion: @escaping (Result<ApiResponse, ApiError>) -> Void
    ) {
        if context.error != nil {
            completion(.failure(.init(errorType: .requestError, context: context)))
            return
        }
        guard
            let httpResponse = context.urlResponse as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode)
        else {
            completion(.failure(.init(errorType: .invalidResponse, context: context)))
            return
        }
        
        guard let data = context.data else {
            completion(.failure(.init(errorType: .invalidaData, context: context)))
            return
        }
        completion(.success(.init(data: data, context: context)))
    }
}
