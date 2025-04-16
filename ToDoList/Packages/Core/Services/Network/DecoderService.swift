import UIKit

final class DecoderService {}

extension DecoderService: DecoderServicable {
    func decode <T: Decodable>(data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
}
