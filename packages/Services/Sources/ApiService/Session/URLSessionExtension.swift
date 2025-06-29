import Foundation

extension URLSession: SessionProtocol {
    func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, (any Error)?) -> Void
    ) -> any SessionTaskProtocol {
        let task: URLSessionDataTask = dataTask(
            with: url,
            completionHandler: completionHandler
        )
        return task
    }
}

extension URLSessionDataTask: SessionTaskProtocol {}

