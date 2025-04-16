enum CoreDataErrors: Error {
    case save
    case create
    case read
    case update
    case delete
    
    var errorMessage: String {
        switch self {
        case .save:
            return "Failed to save context"
        case .create:
            return "Failed to create object"
        case .read:
            return "Failed to fetch data"
        case .update:
            return "Failed to update object"
        case .delete:
            return "Failed to delete object"
        }
    }
}
