protocol DeliveryRetailProductsModule: Presentable {
    var onMakeOrdedDidTap: Callback? { get set }
    typealias FavoriteButtonTapped = (FavoriteStatus) -> Void
    typealias Alcohol = () -> Void
    var alcohol: Alcohol? { get set }
    var favoriteButtonTapped: FavoriteButtonTapped? { get set }
}
