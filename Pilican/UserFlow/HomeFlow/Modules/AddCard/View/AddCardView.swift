import UIKit

class AddCardView: UIView {
    
    let scrollView = UIScrollView()
    
    lazy var scancardTextField: CardNumberTextField = {
        let tf = CardNumberTextField()
        tf.placeholder = "0000 0000 0000 0000"
        tf.textAlignment = .left
        tf.textColor = .pilicanBlack
        tf.font  = .semibold16
        tf.backgroundColor = .background
        tf.layer.masksToBounds = true
        tf.layer.cornerRadius  = 16
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.setLeftPaddingPoints(12)
        tf.setRightPaddingPoints(12)
        return tf
    }()
    
    lazy var imageView: UIImageView = {
        let iv  = UIImageView()
        iv.image = UIImage(named: "cardLogo")?.withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var cardNumberTitle: UILabel = {
        let l  = UILabel()
        l.text = "Номер карты"
        l.textAlignment = .left
        l.font = .semibold16
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var userNameTitle: UILabel = {
        let l = UILabel()
        l.text = "Имя на карте"
        l.textAlignment = .left
        l.textColor = .black
        l.font = .semibold16
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var userNameCardTextField: NameTextField = {
        let tf  = NameTextField()
        tf.placeholder = "Имя Фамилия"
        tf.textAlignment = .left
        tf.textColor = .pilicanBlack
        tf.font = .semibold16
        tf.backgroundColor = .background
        tf.layer.masksToBounds = true
        tf.layer.cornerRadius = 16
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.setLeftPaddingPoints(12)
        return tf
    }()
    
    lazy var dateTitle: UILabel = {
        let l = UILabel()
        l.text = "Срок действие"
        l.textAlignment = .left
        l.font = .semibold16
        l.textColor = .black
        return l
    }()
    
    lazy var dateTextField: DateTextField = {
        let tf = DateTextField()
        tf.placeholder = "ММ / YYYY"
        tf.textAlignment = .left
        tf.textColor = .pilicanBlack
        tf.font = .semibold16
        tf.backgroundColor  = .background
        tf.layer.masksToBounds = true
        tf.layer.cornerRadius  = 16
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.setLeftPaddingPoints(12)
        tf.setRightPaddingPoints(12)
        return tf
    }()
    
    lazy var cvcTitle: UILabel = {
        let l = UILabel()
        l.text = "CVV / CVC"
        l.textAlignment = .left
        l.textColor = .black
        l.font = .semibold16
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var cvcTextField: CVVTextField = {
        let tf                 = CVVTextField()
        tf.placeholder         = "CVC"
        tf.textAlignment       = .left
        tf.textColor           = .pilicanBlack
        tf.font                = .semibold16
        tf.backgroundColor     = .background
        tf.isSecureTextEntry   = true
        tf.layer.masksToBounds = true
        tf.layer.cornerRadius  = 16
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.setLeftPaddingPoints(12)
        tf.setRightPaddingPoints(12)
        //        tf.constrainWidth(constant: 150)
        return tf
    }()
    
    lazy var correctLabel: UILabel = {
        let l = UILabel()
        l.text = "Проверьте правильно ли введены данные"
        l.textColor = .pilicanGray
        l.textAlignment = .center
        l.font = .medium12
        return l
    }()
    
    lazy var addCardButton: UIButton = {
        let b = UIButton()
        b.setTitle("Добавить карту", for: .normal)
        b.setImage(UIImage(named: "lock")?.withRenderingMode(.alwaysOriginal), for: .normal)
        b.imageEdgeInsets.left = -40
        b.titleLabel?.font = .semibold16
        b.titleLabel?.textColor = .white
        b.backgroundColor = UIColor(red: 1, green: 0.596, blue: 0, alpha: 0.4)
        b.layer.cornerRadius = 16
        b.isEnabled = false
        return b
    }()
    
    lazy var infoLabel: UILabel = {
        let l = UILabel()
        let attributedText = NSMutableAttributedString(string: "Безопасность транзакций\n гарантирует ", attributes: [NSAttributedString.Key.font : UIFont.medium16])
        attributedText.append(NSAttributedString(string: "CLOUD PAYMENTS", attributes: [NSAttributedString.Key.font : UIFont.book12]))
        l.attributedText = attributedText
        l.textAlignment = .center
        l.numberOfLines = 2
        l.textColor = .pilicanBlack
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var cloudPayLogo: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "logoCloudPay")?.withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let view = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        scrollView.alwaysBounceVertical = true
        scrollView.bounces = true
    }
    
    private func setupInitialLayout() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { $0.edges.width.height.equalToSuperview() }
        
        let timeStackView = UIStackView(
            views: [dateTitle, dateTextField],
            axis: .vertical,
            distribution: .fillProportionally,
            spacing: 5)
        
        let cvvStacView = UIStackView(
            views: [cvcTitle, cvcTextField],
            axis: .vertical,
            distribution: .fillProportionally,
            spacing: 5)
        
        let horizontalStackView = UIStackView(
            views: [timeStackView, cvvStacView],
            axis: .horizontal,
            distribution: .fillEqually,
            spacing: 40)
        
        let fullStackView = UIStackView(
            views: [imageView, cardNumberTitle, scancardTextField, userNameTitle, userNameCardTextField, horizontalStackView , addCardButton, infoLabel, cloudPayLogo, UIView()],
            axis: .vertical,
            distribution: .fill,
            spacing: 15)
        
        scrollView.addSubview(fullStackView)
        fullStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalTo(self).inset(20)
        }
        
        [scancardTextField, userNameCardTextField, cvcTextField, dateTextField, addCardButton].forEach { [unowned self] view in
            self.makeHeight(view: view, size: 60)
        }
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(147)
            make.centerX.equalToSuperview()
            make.width.equalTo(185)
        }
        
        cloudPayLogo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
    }
    
    func makeHeight(view: UIView, size: CGFloat) {
        view.snp.makeConstraints { $0.height.equalTo(size) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


