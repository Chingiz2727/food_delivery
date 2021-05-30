import YandexMobileMetrica

enum CommerceAttribute {
    case openPage(query: String)
    case openCard(productId: Int, price: String, productName: String)
    case addProduct(query: String, productId: Int, price: String, productName: String)
    case removeProduct(query: String, productId: Int, price: String, productName: String)
    case beginCommerce(query: String, products: [YMKOrderProduct])
    case purchaseCommerce(query: String, products: [YMKOrderProduct])
}

protocol PillicanCommerceEngine: class {
    func sendAnalyticsEvent(attrribute: CommerceAttribute)
}


final class YandexCommerceEngine: PillicanCommerceEngine {
    func sendAnalyticsEvent(attrribute: CommerceAttribute) {
        switch attrribute {
        case let.openPage(query):
            sendOpenPage(query: query)
        case let.addProduct(query, productId, price, productName):
            addProduct(name: query, productId: productId, price: price, productName: productName)
        case let.removeProduct(query, productId, price, productName):
            removeProduct(name: query, productId: productId, price: price, productName: productName)
        case let.beginCommerce(query, products):
            beginCommerce(query: query, products: products)
        case let.purchaseCommerce(query, products):
            purchaseCommerce(query: query, products: products)
        default:
            break
        }
    }
    
    private func sendOpenPage(query: String) {
        let screen = YMMECommerceScreen(
            name: "Список продуктов",
            categoryComponents: [""],
            searchQuery: query,
            payload: ["full_screen": "true"]
        )
        // Sending an e-commerce event.
        YMMYandexMetrica.report(eCommerce: .showScreenEvent(screen: screen)) { error in
            print(error)
        }
    }
    
    private func addProduct(name: String, productId: Int, price: String, productName: String) {
        let screen = YMMECommerceScreen(
            name: "Карточка товара",
            categoryComponents: nil,
            searchQuery: name,
            payload: ["full_screen": "true"]
        )
        // Creating an actualPrice object.
        let actualPrice = YMMECommercePrice(
            fiat: .init(unit: "USD", value: .init(string: price)),internalComponents: nil)
        let product = YMMECommerceProduct(sku: "\(productId)", name: productName, categoryComponents: nil, payload: ["full_screen": "true"], actualPrice: actualPrice, originalPrice: nil, promoCodes: nil)
        let referrer = YMMECommerceReferrer(type: "button", identifier: name, screen: screen)
        
        let addedItems = YMMECommerceCartItem(product: product, quantity: .init(string: "1"), revenue: actualPrice, referrer: referrer)
        
        YMMYandexMetrica.report(eCommerce: .addCartItemEvent(cartItem: addedItems), onFailure: nil)
    }
    
    private func removeProduct(name: String, productId: Int, price: String, productName: String) {
        let screen = YMMECommerceScreen(
            name: "Карточка товара",
            categoryComponents: nil,
            searchQuery: name,
            payload: ["full_screen": "true"]
        )
        // Creating an actualPrice object.
        let actualPrice = YMMECommercePrice(
            fiat: .init(unit: "USD", value: .init(string: price)),internalComponents: nil)
        let product = YMMECommerceProduct(sku: "\(productId)", name: productName, categoryComponents: nil, payload: ["full_screen": "true"], actualPrice: actualPrice, originalPrice: nil, promoCodes: nil)
        let referrer = YMMECommerceReferrer(type: "button", identifier: name, screen: screen)
        
        let removedItems = YMMECommerceCartItem(product: product, quantity: .init(string: "1"), revenue: actualPrice, referrer: referrer)
        
        YMMYandexMetrica.report(eCommerce: .removeCartItemEvent(cartItem: removedItems), onFailure: nil)
    }
    
    private func beginCommerce(query: String, products: [YMKOrderProduct]) {
        // Creating a screen object.
        let screen = YMMECommerceScreen(
            name: "Оформление заказа",
            categoryComponents: [],
            searchQuery: query,
            payload: ["full_screen": "true"]
        )
        
        
        let addedCartItems: [YMMECommerceCartItem] = products.map { commerceProduct in
            // Creating an actualPrice object.
            let price = "\(commerceProduct.productCount * commerceProduct.productPrice)"

            let originalPrice = YMMECommercePrice(
                fiat: .init(unit: "USD", value: .init(string: price)),
                internalComponents: []
            )
            // Creating a product object.
            let product = YMMECommerceProduct(
                sku: "\(commerceProduct.productId)",
                name: commerceProduct.productName,
                categoryComponents: [],
                payload: ["full_screen": "true"],
                actualPrice: nil,
                originalPrice: originalPrice ,
                promoCodes: nil
            )
            // Creating a referrer object.
            let referrer = YMMECommerceReferrer(type: query, identifier: query, screen: screen)
            // Creating a cartItem object.
            return YMMECommerceCartItem(product: product, quantity: .init(string: "\(commerceProduct.productCount)"), revenue: originalPrice, referrer: referrer)
        }
        
        // Creating an order object.
        let order = YMMECommerceOrder(
            identifier: query,
            cartItems: addedCartItems
        )
        
        // Sending an e-commerce event.
        YMMYandexMetrica.report(eCommerce: .beginCheckoutEvent(order:order), onFailure: nil)
    }
    
    private func purchaseCommerce(query: String, products: [YMKOrderProduct]) {
        // Creating a screen object.
        let screen = YMMECommerceScreen(
            name: "Оформление заказа",
            categoryComponents: [""],
            searchQuery: query,
            payload: ["full_screen": "true"]
        )
        
        products.forEach {  [unowned self]  productRevenue in
            self.makeRevenue(product: productRevenue)
        }
        
        let addedCartItems: [YMMECommerceCartItem] = products.map { commerceProduct in
            // Creating an actualPrice object.
            let price = "\(commerceProduct.productCount * commerceProduct.productPrice)"
            let originalPrice = YMMECommercePrice(
                fiat: .init(unit: "USD", value: .init(string: price)),
                internalComponents: []
            )
            // Creating a product object.
            let product = YMMECommerceProduct(
                sku: "\(commerceProduct.productId)",
                name: commerceProduct.productName,
                categoryComponents: [],
                payload: ["full_screen": "true"],
                actualPrice: nil,
                originalPrice: originalPrice ,
                promoCodes: nil
            )
            // Creating a referrer object.
            let referrer = YMMECommerceReferrer(type: query, identifier: query, screen: screen)
            // Creating a cartItem object.
            return YMMECommerceCartItem(product: product, quantity: .init(string: "\(commerceProduct.productCount)"), revenue: originalPrice, referrer: referrer)
        }
        
        // Creating an order object.
        let order = YMMECommerceOrder(
            identifier: query,
            cartItems: addedCartItems
        )
        
        // Sending an e-commerce event.
        YMMYandexMetrica.report(eCommerce: .purchaseEvent(order: order), onFailure: nil)
    }
    
    private func makeRevenue(product: YMKOrderProduct) {
        let revenueInfo = YMMMutableRevenueInfo.init(priceDecimal:NSDecimalNumber.init(integerLiteral: product.productPrice * product.productCount), currency: "KZT")
        revenueInfo.productID = "\(product.productName)"
        revenueInfo.quantity = UInt(product.productCount)
        revenueInfo.payload = ["OrderID": "Identifier", "source": "AppStore"]
        let reporter = YMMYandexMetrica.reporter(forApiKey: AppEnviroment.yandexMetricKey)
        reporter?.reportRevenue(revenueInfo, onFailure: { (error) in
            print("REPORT ERROR: \(error.localizedDescription)")
        })
    }
}

struct YMKOrderProduct {
    let productId: Int
    let productName: String
    let productCount: Int
    let productPrice: Int
}
