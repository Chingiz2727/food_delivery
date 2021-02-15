import UIKit

public extension UIViewController {

  func showSimpleAlert(title: String?, message: String?) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "error_alert_dismiss", style: .default, handler: nil))
    present(alertController, animated: true, completion: nil)
  }

  func showErrorInAlert(_ error: Error) {
    let controller = UIAlertController(
      title: "error_alert_title",
      message: error.localizedDescription,
      preferredStyle: .alert
    )
    let action = UIAlertAction(title: "error_alert_dismiss", style: .cancel) { _ in
      controller.dismiss(animated: true, completion: nil)
    }
    controller.addAction(action)

    present(controller, animated: true, completion: nil)
  }

  func showErrorInAlert(text: String) {
    let controller = UIAlertController(
      title: "error_alert_title",
      message: text,
      preferredStyle: .alert
    )
    let action = UIAlertAction(title: "error_alert_dismiss", style: .cancel) { _ in
      controller.dismiss(animated: true, completion: nil)
    }
    controller.addAction(action)

    present(controller, animated: true, completion: nil)
  }

  func showConfirmAlert(
    message alertMessage: String?,
    style: UIAlertController.Style = .actionSheet,
    result: @escaping (Bool) -> Void
  ) {

    let alertControler = UIAlertController(
      title: "confirm_alert_title",
      message: alertMessage,
      preferredStyle: style
    )
    alertControler.addAction(UIAlertAction(
      title: "confirm_alert_confirm",
      style: .destructive,
      handler: { _ in result(true) }
    ))
    alertControler.addAction(UIAlertAction(
      title: "confirm_alert_cancel",
      style: .cancel,
      handler: { _ in result(false) }
    ))
    present(alertControler, animated: true, completion: nil)
  }

  func showErrorInAlert(_ error: Error, onDismiss: @escaping () -> Void) {
    let controller = UIAlertController(
      title: "error_alert_title",
      message: error.localizedDescription,
      preferredStyle: .alert
    )
    let action = UIAlertAction(title: "error_alert_dismiss", style: .cancel) { _ in
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
      title: "cancel",
      style: .cancel
    ))

    present(alertControler, animated: true)
  }
}
