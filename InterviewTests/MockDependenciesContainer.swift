@testable import Interview
import ApiServicing

final class MockDependenciesContainer: Dependencies {
    var apiServiceMock = MockApiServicing()
    var apiService: ApiServicing { apiServiceMock }
    
    var imageServiceMock = MockApiServicing()
    var imageService: ApiServicing { imageServiceMock }
}
