import Foundation

extension String {
    func isStringContainsOnlyNumbers() -> Bool {
        return self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
