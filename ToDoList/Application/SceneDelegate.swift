import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private var coordinator: AppCoordinator?
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let coordinator = AppCoordinator(windowScene: windowScene)
        coordinator.start()
        self.coordinator = coordinator
    }
}
