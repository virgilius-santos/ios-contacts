import ApiServicing
import ApiService
import UIKit

final class ContactCell: UITableViewCell {
    static let identifier = String(describing: ContactCell.self)
    
    let placeholder = UIImage(systemName: "photo.on.rectangle")
    
    lazy var contactImage: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    lazy var fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var apiService: ApiServicing = ApiService().cached().mainThreadSafe
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureViews()
    }
    
    override func prepareForReuse() {
        fullnameLabel.text = ""
        contactImage.image = placeholder
    }
    
    func configureViews() {
        contentView.addSubview(contactImage)
        contentView.addSubview(fullnameLabel)
        
        contactImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        contactImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        contactImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        contactImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        fullnameLabel.leadingAnchor.constraint(equalTo: contactImage.trailingAnchor, constant: 16).isActive = true
        fullnameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        fullnameLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        fullnameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}

extension ContactCell {
    func setupViewModel(_ contact: ContactViewModel) {
        fullnameLabel.text = contact.name
        apiService.fetch(request: .init(urlString: contact.imageURL.absoluteString)) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                contactImage.image = UIImage(data: response.data) ?? placeholder
            case .failure:
                contactImage.image = placeholder
            }
        }
    }
}
