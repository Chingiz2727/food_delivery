//
//  Profile.swift
//  Pilican
//
//  Created by kairzhan on 3/3/21.
//

import Foundation

struct Profile: Codable {
    let firstName: String
    let sex: Bool
    let birthDay: String
    let city: City
}
