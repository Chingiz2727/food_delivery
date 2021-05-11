import UIKit
import SwiftMessages

public class CardSegue: SwiftMessagesSegue {
    public init(source: UIViewController, destination: UIViewController, isDraggable: Bool, isDismissOnDimEnabled: Bool) {
		super.init(identifier: nil, source: source, destination: destination)
        keyboardTrackingView = KeyboardTrackingView()
        dimMode = .gray(interactive: isDismissOnDimEnabled)
        interactiveHide = isDraggable
        configure(layout: .centered)
        messageView.configureNoDropShadow()
	}
}
