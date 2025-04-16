import UIKit

final class ToDoApiService {
    private let decoderService: DecoderServicable
    private let networkService: Networkable
    
    init(decoderService: DecoderServicable = DecoderService(), networkService: Networkable = NetworkService()) {
        self.decoderService = decoderService
        self.networkService = networkService
    }
}

extension ToDoApiService: ToDoApiServicable {
    func loadData() async throws -> Todos {
        let data = try await networkService.request(urlString: "https://dummyjson.com/todos")
        let response: Todos = try decoderService.decode(data: data)
        return response
    }
}
