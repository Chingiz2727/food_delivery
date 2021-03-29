//
//  ScanRetailResponse.swift
//  Pilican
//
//  Created by kairzhan on 3/25/21.
//

import Foundation

struct ScanRetailResponse: Codable {
    let orderId: Int
    let fullName: String
    let type: Int
    let retail: Retail
}
