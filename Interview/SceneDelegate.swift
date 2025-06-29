import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let viewModel = ListContactsViewModel()
            let controller = ListContactsViewController(
                viewModel: viewModel
            )
            viewModel.displayLogic = controller
            window.rootViewController = UINavigationController(rootViewController: controller)
            self.window = window
            window.makeKeyAndVisible()
            
        }
    }
}

