import UIKit

final class OrderProgressView: UIView {
    private let progressCircle = UIView()
    private let progressLine = UIView()
    private let progressImg = UIImageView()
    private let progressLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupInitialLayout()
        configureView()
    }
    
    func setupStatus(status: OrderStatus, passStatus: OrderPassStatus) {
        let attributedText = NSMutableAttributedString(
            string: "Статус: ",
            attributes: [NSMutableAttributedString.Key.font: UIFont.medium14,
                         NSAttributedString.Key.foregroundColor: UIColor.pilicanBlack])
        
        attributedText.append(NSAttributedString(
                                string: status.title,
                                attributes: [NSMutableAttributedString.Key.font: UIFont.semibold14]))
        switch passStatus {
        case .disabled:
            progressImg.image = status.disabledImage
        case .onPassed:
            attributedText.setColorForText(textForAttribute: status.title, withColor: .primary)
            progressImg.image = status.onStatusImage
            progressCircle.backgroundColor = .primary
            progressLine.backgroundColor = .primary
        case .onProgress:
            attributedText.setColorForText(textForAttribute: status.title, withColor: .primary)
            progressImg.image = status.onStatusImage
            progressCircle.blink()
            progressLine.blink()
        }
        progressLabel.attributedText = attributedText
    }
    
    private func setupInitialLayout() {
        addSubview(progressCircle)
        addSubview(progressLine)
        addSubview(progressImg)
        addSubview(progressLabel)
        
        progressCircle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.size.equalTo(20)
            make.leading.equalToSuperview().inset(15)
        }
        
        progressLine.snp.makeConstraints { make in
            make.top.equalTo(progressCircle.snp.bottom)
            make.centerX.equalTo(progressCircle)
            make.width.equalTo(2)
            make.bottom.equalToSuperview()
        }
        
        progressImg.snp.makeConstraints { make in
            make.leading.equalTo(progressCircle.snp.trailing).offset(40)
            make.size.equalTo(35)
        }
        progressLabel.snp.makeConstraints { make in
            make.top.equalTo(progressImg.snp.bottom).offset(5)
            make.leading.equalTo(progressImg)
        }
    }
    
    private func configureView() {
        progressCircle.backgroundColor = .pilicanGray
        progressLine.backgroundColor = .pilicanGray
        progressLabel.textColor = .pilicanGray
        progressLabel.textAlignment = .left
        progressCircle.layer.cornerRadius = 10
    }
}

extension UIView {
    func blink(enabled: Bool = true, duration: CFTimeInterval = 0.5, stopAfter: CFTimeInterval = 0.0 ) {
            enabled ? (UIView.animate(withDuration: duration, //Time duration you want,
                delay: 0.0,
                options: [.curveEaseInOut, .autoreverse, .repeat],
                animations: { [weak self] in self?.alpha = 0.0 },
                completion: { [weak self] _ in self?.alpha = 1.0 })) : self.layer.removeAllAnimations()
            if !stopAfter.isEqual(to: 0.0) && enabled {
                DispatchQueue.main.asyncAfter(deadline: .now() + stopAfter) { [weak self] in
                    self?.layer.removeAllAnimations()
                }
            }
        }
}

extension NSMutableAttributedString {

    func setColorForText(textForAttribute: String, withColor color: UIColor ) {
        
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)

        // Swift 4.2 and above
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)

        // Swift 4.1 and below
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }

}
