import UIKit

protocol Router {
    func push(_ viewController: UIViewController, animated: Bool)
    func pop(animated: Bool)
    func setRoot(viewController: UIViewController, animated: Bool)
    func present(viewController: UIViewController, animated: Bool)
    func dismiss(animated: Bool)
}

protocol BackRoutingLogic {
    func back()
}
