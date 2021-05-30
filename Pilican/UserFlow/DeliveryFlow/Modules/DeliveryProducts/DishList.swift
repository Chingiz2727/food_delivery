import RxSwift

enum DishListAction {
    case addToDish(Product)
    case removeFromDish(Product)
}

final class DishList {
    
    var utensils = 0
    private let analytics = assembler.resolver.resolve(PillicanAnalyticManager.self)!
    private let commerceManager = assembler.resolver.resolve(PillicanCommerceManager.self)!
    
    var retail: DeliveryRetail? {
        didSet {
            if let retail = retail {
                retailSubject.onNext(retail)
            }
        }
    }
    
//    let productList: BehaviorSubject<[ProductCategory]> = .init(value: [])
    let retailSubject = PublishSubject<DeliveryRetail>()
    let wishDishList: BehaviorSubject<[Product]> = .init(value: [])

    var products: [Product] = .init() {
        didSet {
            print(products)
        }
    }

    private let disposeBag = DisposeBag()

    init() {
    }

    func changeDishList(dishAction: DishListAction) -> Product {
        switch dishAction {
        case let .addToDish(product):
            return addToDish(product: product)
        case let .removeFromDish(product):
            return removeFromDish(product: product)
        }
    }

    private func addToDish(product: Product) -> Product {
        var product = product
        product.shoppingCount = product.shoppingCount == nil ? 1 : product.shoppingCount
        if products.contains(where: { $0.id == product.id }) {
            if let row = products.firstIndex(where: { $0.id == product.id }) {
                products[row].shoppingCount! += 1
                product.shoppingCount! += 1
            }
        } else {
            product.shoppingCount = 1
            products.append(product)
            commerceManager.log(.addProduct(query: retail?.name ?? "", productId: product.id, price: "\(product.price)", productName: product.name))
        }
        wishDishList.onNext(products)
        return product
    }

    private func removeFromDish(product: Product) -> Product {
        var product = product
        product.shoppingCount = product.shoppingCount == nil ? 0 : product.shoppingCount
        if products.contains(where: { $0.id == product.id }) {
            if let row = products.firstIndex(where: { $0.id == product.id }) {
                guard let count = products[row].shoppingCount else { return product }
                if count == 1 {
                    products.remove(at: row)
                    product.shoppingCount! = 0
                } else {
                    products[row].shoppingCount! -= 1
                    product.shoppingCount! -= 1
                }
            }
        }
        wishDishList.onNext(products)
        return product
    }

    func appendToDishList(products: [Product]) {
        wishDishList.onNext(products)
    }
    
    func checkForContainProductOnDish(listCategory: [ProductCategory]) -> [ProductCategory] {
        var listCategory = listCategory
        listCategory.enumerated().forEach { section, category in
            category.dishes.enumerated().forEach { row, product in
                products.forEach { dishProduct in
                    if dishProduct.id == product.id {
                        listCategory[section].dishes[row] = dishProduct
                    }
                }
            }
        }
        return listCategory
    }
}
