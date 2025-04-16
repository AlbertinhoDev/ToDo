import UIKit

protocol SearchDelegate: AnyObject {
    func searchTask(searchText: String)
}

final class SearchTableViewCell: UITableViewCell {
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.backgroundColor = .clear
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.layer.borderWidth = 0
        searchBar.searchTextField.textColor = UIColor(named: "SearchLabel")
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
    
    weak var delegate: SearchDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.searchBar.delegate = self
        setupCell()
    }
    
    func currentSearchState() -> (text: String, isFirstResponder: Bool) {
        return (searchBar.text ?? "", searchBar.isFirstResponder)
    }

    func restoreSearchState(text: String, shouldBecomeFirstResponder: Bool) {
        searchBar.text = text
        if shouldBecomeFirstResponder {
            searchBar.becomeFirstResponder()
        }
    }
    
    private func setupCell() {
        backgroundColor = .clear
        contentView.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            searchBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            searchBar.heightAnchor.constraint(greaterThanOrEqualToConstant: 36)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchTableViewCell: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.searchTask(searchText: searchText)
    }
}
