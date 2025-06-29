import Testing
@testable import ApiService
import ApiServicing
import Foundation

extension ApiServiceTests {
    typealias Sut = ApiService
    
    final class Doubles {
        let urlBase = String.urlStringFixture
        let sessionMock = MockSession()
        
        var anyMessages = AnyMessages()
    }
    
    func makeSut(urlBase: String? = nil) -> (Sut, Doubles) {
        let doubles = Doubles()
        let sut = ApiService(
            urlBase: urlBase ?? doubles.urlBase,
            session: doubles.sessionMock
        )
        doubles.sessionMock.anyMessages = doubles.anyMessages
        doubles.sessionMock.task.anyMessages = doubles.anyMessages
        
        return (sut, doubles)
    }
}

struct ApiServiceTests {
    @Test
    func cancel_whenNoRequestInProgress_shouldDoNothing() {
        let (sut, doubles) = makeSut()
        
        sut.cancel()
        
        equal(doubles.anyMessages, [])
    }
    
    @Test
    func cancel_whenRequestInProgress_shouldCancelTheTask() {
        let (sut, doubles) = makeSut()
        
        assertFetchStartedCorrectly(sut: sut, doubles: doubles)
        
        sut.cancel()
        
        equal(doubles.anyMessages, [
            MockSessionTask.Message.cancel
        ])
    }
    
    @Test
    func fetch_whenCalledTwice_shouldCancelPreviousTaskAndResumeNewOne() {
        let (sut, doubles) = makeSut()
        
        assertFetchStartedCorrectly(sut: sut, doubles: doubles)
        
        let urlReceived = URL.fixture(
            urlString: .urlStringFixture + "path"
        )
        
        sut.fetch(request: ApiRequest.validRequest) { [weak doubles] result in
            doubles?.anyMessages.appendLast(of: [result])
        }
        
        equal(doubles.anyMessages, [
            MockSession.Message.dataTask(urlReceived),
            MockSessionTask.Message.cancel,
            MockSessionTask.Message.resume
        ])
    }
    
    @Test
    func fetch_whenUrlIsInvalid_shouldReturnUrlBuildingFailedError() {
        let invalidBase = ""
        let requestSent = ApiRequest.fixture()
        let errorReceived = ApiError.fixture(errorType: .urlBuildingFailed)
        let (sut, doubles) = makeSut(urlBase: invalidBase)
        
        sut.fetch(request: requestSent) { [weak doubles] result in
            doubles?.anyMessages.appendLast(of: [result])
        }
        
        equal(doubles.anyMessages, [
            Result<ApiResponse, ApiError>.failure(errorReceived)
        ])
    }
    
    @Test
    func fetch_whenRequestSucceeds_shouldStartDataTaskAndResume() {
        let (sut, doubles) = makeSut()
        
        assertFetchStartedCorrectly(sut: sut, doubles: doubles)
    }
    
    @Test(arguments: [
        (ApiContext.fixture(request: .validRequest, error: ApiErrorType.fixture() as NSError),  ApiErrorType.requestError),
        (ApiContext.fixture(request: .validRequest, urlResponse: .fixture(statusCode: 199)),  ApiErrorType.invalidResponse),
        (ApiContext.fixture(request: .validRequest, urlResponse: .fixture(statusCode: 300)),  ApiErrorType.invalidResponse),
        (ApiContext.fixture(request: .validRequest, urlResponse: .fixture(statusCode: 200)),  ApiErrorType.invalidaData)
    ])
    func fetch_whenResponseIsInvalid_shouldReturnExpectedApiError(
        args: (context: ApiContext, errorType: ApiErrorType)
    ) {
        let (sut, doubles) = makeSut()
        let errorReceived = ApiError.fixture(errorType: args.errorType, context: args.context)
        
        assertFetchStartedCorrectly(sut: sut, doubles: doubles)
        
        doubles.sessionMock.simulateResponse(
            data: args.context.data,
            response: args.context.urlResponse,
            error: args.context.error
        )
        
        equal(doubles.anyMessages, [
            Result<ApiResponse, ApiError>.failure(errorReceived)
        ])
    }
    
    @Test
    func fetch_whenResponseIsSuccess_shouldReturnApiResponse() {
        let (sut, doubles) = makeSut()
        let context = ApiContext.fixture(
            request: .validRequest,
            data: Data(),
            urlResponse: .fixture(statusCode: 200)
        )
        assertFetchStartedCorrectly(sut: sut, doubles: doubles)
        
        doubles.sessionMock.simulateResponse(
            data: context.data,
            response: context.urlResponse,
            error: context.error
        )
        
        equal(doubles.anyMessages, [
            Result<ApiResponse, ApiError>.success(.fixture(context: context))
        ])
    }
    
    func assertFetchStartedCorrectly(
        sut: Sut,
        doubles: Doubles,
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        let urlReceived = URL.fixture(
            urlString: .urlStringFixture + "path"
        )
        
        sut.fetch(request: ApiRequest.validRequest) { [weak doubles] result in
            doubles?.anyMessages.appendLast(of: [result])
        }
        
        equal(doubles.anyMessages, [
            MockSession.Message.dataTask(urlReceived),
            MockSessionTask.Message.resume
        ], sourceLocation: sourceLocation)
        
        doubles.anyMessages.clearMessages()
    }
}
