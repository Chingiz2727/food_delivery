import RxSwift
import UIKit

final class CityPickerViewDelegate: NSObject, UIPickerViewDelegate {
    var selectedCity = PublishSubject<City>()
    var city: [City] = []

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        selectedCity.onNext(city[row])
    }
}
