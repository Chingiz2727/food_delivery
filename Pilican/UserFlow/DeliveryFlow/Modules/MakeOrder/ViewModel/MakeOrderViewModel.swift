import RxSwift

final class MakeOrderViewModel {
    
    let dishList: DishList
    let userInfo: UserInfoStorage
    
    init(dishList: DishList, userInfo: UserInfoStorage) {
        self.dishList = dishList
        self.userInfo = userInfo
    }
}
