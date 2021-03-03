//
//  User.swift
//  Pilican
//
//  Created by kairzhan on 3/3/21.
//

import Foundation

struct User: Codable {
    let qrCode: String?
    let username: String
    let promoCode: String
    let balance: Int
}
