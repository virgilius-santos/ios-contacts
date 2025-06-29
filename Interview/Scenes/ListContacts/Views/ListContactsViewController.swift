import UIKit

protocol ListContactsDisplayLogic: AnyObject {
    func displayTitle(_ title: String)
    func displayContacts()
    func showMessage(title: String, message: String)
    func startLoading()
    func stopLoading()
}

final class ListContactsViewController: UIViewController, Alertable {
    lazy var activity: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.hidesWhenStopped = true
        return activity
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 120
        tableView.register(ContactCell.self, forCellReuseIdentifier: ContactCell.identifier)
        tableView.backgroundView = activity
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    let viewModel: ListContactsViewModeling
    
    init(
        viewModel: ListContactsViewModeling
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        nil
    }
    
    override func loadView() {
        self.view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadContacts()
    }
}

extension ListContactsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfContacts()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ContactCell.identifier,
            for: indexPath
        )
        if let cell = cell as? ContactCell, let contact = viewModel.contact(at: indexPath.row) {
            cell.setupViewModel(contact)
        }
        return cell
    }
}

extension ListContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectedContact(at: indexPath.row)
    }
}

extension ListContactsViewController: ListContactsDisplayLogic {
    func displayTitle(_ title: String) {
        self.title = title
    }
    
    func displayContacts() {
        tableView.reloadData()
    }
    
    func showMessage(title: String, message: String) {
        showAlert(title: title, message: message)
    }
    
    func startLoading() {
        activity.startAnimating()
    }
    
    func stopLoading() {
        activity.stopAnimating()
    }
}
