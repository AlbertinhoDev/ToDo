enum SectionType {
    case title
    case search
    case tasks
}

enum RowType {
    case title
    case search
    case task
}

struct Section {
    let type: SectionType
    var rows: [RowType]
}
