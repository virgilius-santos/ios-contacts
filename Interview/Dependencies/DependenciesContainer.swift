import Foundation
import ApiService
import ApiServicing
import UIKit

typealias Dependencies = HasApiService
& HasImageService

final class DependenciesContainer: Dependencies {
    var apiService: ApiServicing {
        // TODO: Mover urlBase para configuração do CI
        ApiService(urlBase: "https://669ff1b9b132e2c136ffa741.mockapi.io/")
            .mainThreadSafe
    }
    
    var imageService: ApiServicing {
        ApiService().cached().mainThreadSafe
    }
}
