import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let dependencies = DependenciesContainer()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            // TODO: Criar coordinator para fazer o roteamento
            let controller = ListContactsFactory(dependencies: dependencies).make()
            window.rootViewController = UINavigationController(rootViewController: controller)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
