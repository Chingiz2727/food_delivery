//
//  PillicanCommerce.swift
//  Pilican
//
//  Created by Чингиз Куандык on 29.05.2021.
//
import YandexMobileMetrica
import Foundation

final class PillicanCommerceManager {
    
    private let engine: PillicanCommerceEngine
    
    init(engine: PillicanCommerceEngine) {
        self.engine = engine
    }
    
    func log(_ attribute: CommerceAttribute) {
        engine.sendAnalyticsEvent(attrribute: attribute)
    }
    
}
