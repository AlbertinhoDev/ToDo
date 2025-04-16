import UIKit

final class AppCoordinator {
    private let window: UIWindow
    private let router: Router
    
    init(windowScene: UIWindowScene) {
        let navigationController = UINavigationController()
        navigationController.navigationBar.tintColor = .yellow
        navigationController.isNavigationBarHidden = true
        navigationController.navigationBar.barTintColor = .black
        let router = NavigationRouter(navigtionController: navigationController)
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        self.router = router
    }
}

extension AppCoordinator: Coordinator {
    func start() {
        let flowCoordinator = FlowCoordinator(router: router)
        flowCoordinator.start()
    }
}
