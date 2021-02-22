import UIKit

final class CityPickerViewDataSource: NSObject, UIPickerViewDataSource {
    var city: [City] = []

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        city.count
    }
}
