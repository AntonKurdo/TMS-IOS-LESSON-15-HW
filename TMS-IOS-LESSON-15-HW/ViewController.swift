import UIKit

class ViewController: UIViewController {
    
    let customAlert = CustomAlert()
    
    let button = {
        let button = UIButton()
        button.setTitle("Show Alert", for: .normal)
        button.backgroundColor = .black
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        return button
    }()
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        customAlert.delegate = self
        setupButton()
    }

    private func setupButton() {
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor ),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor ),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        button.addAction(UIAction(handler: {_ in 
            self.customAlert.showAlert(title: "What is Lorem Ipsum?", message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.", vc: self)
        }), for: .touchUpInside)
   
    }
}

extension ViewController: CustomAlertDelegate {
    func onSuccessTapped() {
        view.backgroundColor = UIColor.random()
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red:   .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}
