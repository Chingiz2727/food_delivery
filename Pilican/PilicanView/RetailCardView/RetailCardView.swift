import Kingfisher
import UIKit

final class RetailCardView: UIView {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 12
        iv.layer.borderWidth = 0.5
        iv.layer.borderColor = UIColor.primary.cgColor
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(imgUrl: String?) {
        if let url  = imgUrl {
            imageView.kf.setImage(with: URL(string: url))
        }
    }
}

