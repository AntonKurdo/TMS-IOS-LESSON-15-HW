import UIKit

protocol CustomAlertDelegate: AnyObject {
    func onSuccessTapped()
}

class CustomAlert: UIView {
    struct Constants {
        static let alpha = 0.5
        static let alertHorizontalMargin: CGFloat = 20
        static let alertHeight: CGFloat = 310
    }
    
    
    weak var delegate: CustomAlertDelegate?
    
    var backgroundView: UIView!
    
    func showAlert(title: String, message: String, vc: UIViewController) {
        
        guard let targetView  = vc.view else { return  }
        
        backgroundView = {
            let backgroundView = UIView()
            backgroundView.frame = CGRect(x: 0, y: 0, width: targetView.bounds.width, height: targetView.bounds.height)
            backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0)
            return backgroundView
        }()
        
        let alertView = {
            let alertView = UIView()
            alertView.layer.cornerRadius = 16
            alertView.layer.opacity = 1
            alertView.frame = CGRect(x: Constants.alertHorizontalMargin, y: -Constants.alertHeight, width: backgroundView.bounds.width - Constants.alertHorizontalMargin * 2, height: Constants.alertHeight)
            alertView.backgroundColor = .white
            alertView.alpha = 1
            return alertView
        }()
        
        let titleLabel = {
            let label = UILabel()
            label.text = title
            label.tintColor = .black
            label.font = .boldSystemFont(ofSize: 24)
            label.frame = CGRect(x: 24, y: 24, width: alertView.bounds.width - 48, height: 30)
            label.textAlignment = .center
            return label
        }()
        
        let messageLabel = {
            let label = UILabel()
            label.text = message
            label.tintColor = .black
            label.font = .boldSystemFont(ofSize: 16)
            label.frame = CGRect(x: 16, y: Int(titleLabel.frame.maxY) + 8, width: Int(alertView.bounds.width) - 32, height: 170)
            label.textAlignment = .center
            label.numberOfLines = 0
            label.adjustsFontSizeToFitWidth = true
            return label
        }()
        
        let stackView = {
            let stackView = UIStackView()
            stackView.frame = CGRect(x: 16, y: Int(messageLabel.frame.maxY) + 16, width: Int(alertView.bounds.width) - 32, height: 50)
            stackView.spacing = 16
            stackView.distribution = .fillEqually
            return stackView
        }()
        
        let successBtn = {
            let button = UIButton()
            button.setTitle("Success", for: .normal)
            button.backgroundColor = .systemGreen
            button.layer.cornerRadius = 16
            button.addAction(UIAction(handler: {_ in
                self.delegate?.onSuccessTapped()
                dissmiss()
            }), for: .touchUpInside)
            return button
        }()
        
        let dismissBtn = {
            let button = UIButton()
            button.setTitle("Cancel", for: .normal)
            button.backgroundColor = .systemRed
            button.layer.cornerRadius = 16
            button.addAction(UIAction(handler: {_ in
                dissmiss()
            }), for: .touchUpInside)
            return button
        }()
        
        stackView.addArrangedSubview(successBtn)
        stackView.addArrangedSubview(dismissBtn)
        alertView.addSubview(titleLabel)
        alertView.addSubview(messageLabel)
        alertView.addSubview(stackView)
        backgroundView.addSubview(alertView)
        targetView.addSubview(backgroundView)
        
        func dissmiss() {
            UIView.animate(withDuration: 0.3, animations: {
                alertView.frame = CGRect(x: Constants.alertHorizontalMargin, y: -Constants.alertHeight, width: self.backgroundView.bounds.width - Constants.alertHorizontalMargin * 2, height: Constants.alertHeight)
            }) { done in
                if done {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0)
                    }) { done in
                        if done {
                            self.backgroundView.removeFromSuperview()
                        }
                    }
                }
            }
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(Constants.alpha)
        }) { done in
            if done {
                UIView.animate(withDuration: 0.3,
                               delay: 0.0,
                               usingSpringWithDamping: 0.4, // значение на сколько пружинить
                               initialSpringVelocity: 0,
                               options: [],
                               animations: {
                    alertView.center = self.backgroundView.center
                })
            }
        }
        
        let tapGesture = UITapGestureRecognizerWithClosure() { _ in
            dissmiss()
        }
        tapGesture.delegate = self
        
        backgroundView.addGestureRecognizer(tapGesture)
    }
}

extension CustomAlert: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == self.backgroundView {
            return true
        }
        return false
    }
}
