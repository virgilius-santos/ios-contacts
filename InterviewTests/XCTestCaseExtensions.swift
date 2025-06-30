import XCTest
import ApiServicing

extension XCTestCase {
    /// Verifica se o objeto foi desalocado, para identificar possíveis memory leaks.
    /// - Parameters:
    ///   - instance: A instância a ser testada.
    ///   - file: Arquivo de origem (default é o local da chamada).
    ///   - line: Linha de origem (default é o local da chamada).
    func assertNoMemoryLeak<T: AnyObject>(
        _ instance: T,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Esperado que a instância seja desalocada. Possível memory leak.", file: file, line: line)
        }
    }
    
    func assertMessages(
        _ actualMessages: AnyMessages,
        _ expectedMessages: [any Equatable],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let expectedMessages = AnyMessages(parameters: expectedMessages.map({ .init($0) }))
        XCTAssertEqual(actualMessages, expectedMessages, file: file, line: line)
    }
}
