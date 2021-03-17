//
//  GenderPickerDataSource.swift
//  Pilican
//
//  Created by kairzhan on 3/12/21.
//

import UIKit

final class GenderPickerViewDataSource: NSObject, UIPickerViewDataSource {
    var gender: [Gender] = []

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        gender.count
    }
}
