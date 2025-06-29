import Foundation

final class ApiStorage {
    private var storage: [ApiRequest: ApiResponse] = [:]
    private let queue = DispatchQueue(label: "ApiStorageQueue", attributes: .concurrent)

    func get(_ request: ApiRequest) -> ApiResponse? {
        queue.sync {
            storage[request]
        }
    }

    func set(_ request: ApiRequest, response: ApiResponse) {
        queue.async(flags: .barrier) {
            self.storage[request] = response
        }
    }
}

extension ApiStorage {
    nonisolated(unsafe) static let `default` = ApiStorage()
}
