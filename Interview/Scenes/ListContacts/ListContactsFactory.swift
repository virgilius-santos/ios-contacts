import Foundation
import ApiService
import ApiServicing
import UIKit

final class ListContactsFactory {
    typealias Dependencies = HasApiService & HasImageService
    
    let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func make() -> UIViewController {
        let service = ListContactService(
            dependencies: dependencies
        )
        let viewModel = ListContactsViewModel(
            dependencies: dependencies,
            service: service
        )
        let controller = ListContactsViewController(
            viewModel: viewModel
        )
        viewModel.displayLogic = controller
        return controller
    }
}
