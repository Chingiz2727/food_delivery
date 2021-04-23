import UIKit

public extension UIViewController {
    
    func showSimpleAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Закрыть", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func showErrorInAlert(_ error: Error) {
        let controller = UIAlertController(
            title: "Ошибка",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "Закрыть", style: .cancel) { _ in
            controller.dismiss(animated: true, completion: nil)
        }
        controller.addAction(action)
        
        present(controller, animated: true, completion: nil)
    }
    
    func showErrorInAlert(text: String) {
        let controller = UIAlertController(
            title: "Ошибка",
            message: text,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "Закрыть", style: .cancel) { _ in
            controller.dismiss(animated: true, completion: nil)
        }
        controller.addAction(action)
        
        present(controller, animated: true, completion: nil)
    }
    
    func showSuccessAlert(handler: @escaping () -> Void) {
        let controller = UIAlertController(title: "", message: "Данные успешно сохранились!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Закрыть", style: .default) { (alert) in
            controller.dismiss(animated: true, completion: handler)}
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }
    
    func showBasketAlert(onhandler: @escaping () -> Void) {
        let controller = UIAlertController(title: "", message: "Вы хотите очистить корзину?", preferredStyle: .alert)
        let clearAction = UIAlertAction(title: "Очистить", style: .destructive, handler:  { _ in
            onhandler()
        })
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { (cancel) in
            self.dismiss(animated: true, completion: nil)
        }
        controller.addAction(clearAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    func showConfirmAlert(
        message alertMessage: String?,
        style: UIAlertController.Style = .actionSheet,
        result: @escaping (Bool) -> Void
    ) {
        
        let alertControler = UIAlertController(
            title: "Подтвердить",
            message: alertMessage,
            preferredStyle: style
        )
        alertControler.addAction(UIAlertAction(
            title: "Отмена",
            style: .destructive,
            handler: { _ in result(true) }
        ))
        alertControler.addAction(UIAlertAction(
            title: "Отмена",
            style: .cancel,
            handler: { _ in result(false) }
        ))
        present(alertControler, animated: true, completion: nil)
    }
    
    func showErrorInAlert(_ error: Error, onDismiss: @escaping () -> Void) {
        let controller = UIAlertController(
            title: "Ошибка",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "Закрыть", style: .cancel) { _ in
            controller.dismiss(animated: true, completion: nil)
            onDismiss()
        }
        controller.addAction(action)
        
        present(controller, animated: true, completion: nil)
    }
    
    func showSelectNumberToCallAlert(_ numbers: [String], onSelect: @escaping (String) -> Void) {
        let alertControler = UIAlertController()
        numbers.forEach { phoneNumber in
            let action = UIAlertAction(title: phoneNumber, style: .default) { _ in
                onSelect(phoneNumber)
            }
            alertControler.addAction(action)
        }
        alertControler.addAction(UIAlertAction(
            title: "Отмена",
            style: .cancel
        ))
        
        present(alertControler, animated: true)
    }
}
