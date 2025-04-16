import UIKit

public protocol Networkable {
    func request(urlString: String) async throws -> Data
}
