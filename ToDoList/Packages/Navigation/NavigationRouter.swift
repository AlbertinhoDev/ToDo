import UIKit

final class NavigationRouter {
    private let navigtionController: UINavigationController
    
    init(navigtionController: UINavigationController) {
        self.navigtionController = navigtionController
    }
}

extension NavigationRouter: Router {
    func push(_ viewController: UIViewController, animated: Bool) {
        navigtionController.pushViewController(viewController, animated: animated)
    }
    
    func pop(animated: Bool) {
        navigtionController.popViewController(animated: animated)
    }
    
    func setRoot(viewController: UIViewController, animated: Bool) {
        navigtionController.setViewControllers([viewController], animated: animated)
    }
    
    func present(viewController: UIViewController, animated: Bool) {
        navigtionController.present(viewController, animated: animated)
    }
    
    func dismiss(animated: Bool) {
        navigtionController.dismiss(animated: animated)
    }
}
