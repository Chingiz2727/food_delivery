protocol DeliveryRetailProductsModule: Presentable {
    typealias FavoriteButtonTapped = (FavoriteStatus) -> Void
    var favoriteButtonTapped: FavoriteButtonTapped? { get set }
}
