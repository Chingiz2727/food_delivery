protocol DeliveryRetailProductsModule: Presentable {
    var onMakeOrdedDidTap: Callback? { get set }
    typealias FavoriteButtonTapped = (FavoriteStatus) -> Void
    var favoriteButtonTapped: FavoriteButtonTapped? { get set }
}
