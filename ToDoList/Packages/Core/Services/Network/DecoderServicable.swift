import UIKit

public protocol DecoderServicable {
    func decode <T: Decodable>(data: Data) throws -> T
}
