import ApiServicing
import Foundation

extension ApiServicing {
    func fetchDecoded<T: Decodable>(
        request: ApiRequest,
        decoder: JSONDecoder = JSONDecoder(),
        returning _: T.Type,
        completion: @escaping (Result<ApiDecoderResponse<T>, ApiError>) -> Void
    ) {
        fetch(request: request) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                do {
                    let decoded = try decoder.decode(T.self, from: response.data)
                    completion(.success(.init(decoded: decoded, response: response)))
                } catch let error {
                    completion(.failure(.init(
                        errorType: .decodeError(error as NSError),
                        context: response.context
                    )))
                }
            }
        }
    }
}
