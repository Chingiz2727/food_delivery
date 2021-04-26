protocol NotificationListModule: Presentable {
    typealias NotificationsListDidSelect = (NotificationsList) -> Void
    typealias CloseButton = () -> Void
    var closeButton: CloseButton? { get set }
    var notificationsListDidSelect: NotificationsListDidSelect? { get set }
}
