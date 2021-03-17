//
//  GenderPickerViewDelegate.swift
//  Pilican
//
//  Created by kairzhan on 3/12/21.
//

import RxSwift
import UIKit

final class GenderPickerViewDelegate: NSObject, UIPickerViewDelegate {
    var selectedGender = PublishSubject<Gender>()
    var gender: [Gender] = []

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGender.onNext(gender[row])
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gender[row].gender
    }
}
