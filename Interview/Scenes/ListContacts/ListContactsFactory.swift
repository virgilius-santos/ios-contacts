import Foundation
import ApiService
import ApiServicing
import UIKit


final class ListContactsFactory {
    func make() -> UIViewController {
        // TODO: Mover urlBase para configuração do CI
        let apiService = ApiService(urlBase: "https://669ff1b9b132e2c136ffa741.mockapi.io/")
            .mainThreadSafe
        let service = ListContactService(apiService: apiService)
        let viewModel = ListContactsViewModel(service: service)
        let controller = ListContactsViewController(
            viewModel: viewModel
        )
        viewModel.displayLogic = controller
        
        return controller
    }
}
