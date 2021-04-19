protocol NotificationListModule: Presentable {
    typealias NotificationsListDidSelect = (NotificationsList) -> Void
    
    var notificationsListDidSelect: NotificationsListDidSelect? { get set }
}
