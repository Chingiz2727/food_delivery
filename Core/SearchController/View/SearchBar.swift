import UIKit

public class SearchBar: UISearchBar {
    
    public override var intrinsicContentSize: CGSize {
        .init(width: UIView.noIntrinsicMetric, height: 48)
    }
    
    public var cornerRadius: CGFloat?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        barStyle = .default
        returnKeyType = .done
        enablesReturnKeyAutomatically = false
        searchBarStyle = .default
        backgroundImage = UIImage()
        setImage(Images.search.image?.withRenderingMode(.alwaysOriginal), for: .search, state: .normal)
        setImage(Images.close.image?.withRenderingMode(.alwaysOriginal), for: .clear, state: .normal)
        clipsToBounds = true
        if #available(iOS 13.0, *) {
            searchTextField.clearButtonMode = .always
            searchTextField.textColor = .pilicanBlack
            searchTextField.backgroundColor = .background
            searchTextField.frame = bounds
            searchTextField.enablesReturnKeyAutomatically = false
            searchTextField.addDoneButtonOnKeyboard()
        } else {
            
        }
        addDoneOnKeyboardWithTarget(nil, action: #selector(hideToolbar))
        tintColor = .primary
    }
    
    
    @objc func hideToolbar() {
        resignFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
}
