import SwiftMessages
import UIKit

class ActionSheetSegue: SwiftMessagesSegue {
	
	init(identifier: String?, source: UIViewController, destination: UIViewController, interactive: Bool) {
		super.init(identifier: identifier, source: source, destination: destination)
		configure(layout: .bottomCard)
		dimMode = .gray(interactive: interactive)
		messageView.configureNoDropShadow()
		messageView.backgroundColor = .clear
		interactiveHide = interactive
	}
	
}
