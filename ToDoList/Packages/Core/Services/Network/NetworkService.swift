import UIKit

public final class NetworkService {}

extension NetworkService: Networkable {
    public func request(urlString: String) async throws -> Data {
        let url = URL(string: urlString)
        guard let url = url else {
            throw URLError(.badURL)
        }
        let urlRequest = URLRequest(url: url)
        let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
        guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        switch httpURLResponse.statusCode {
        case 200...299:
            return data
        default:
            throw URLError(.badServerResponse)
        }
    }
}
