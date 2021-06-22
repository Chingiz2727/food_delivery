//
//  ScanRetailResponse.swift
//  Pilican
//
//  Created by kairzhan on 3/25/21.
//

import Foundation

struct ScanRetailResponse: Codable {
    var orderId: Int
    let fullName: String
    var type: Int
    let retail: Retail
    var transactionId: String?
}
