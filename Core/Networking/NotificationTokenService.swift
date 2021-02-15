public final class NotificationTokenService {

  public static let shared = NotificationTokenService()

  public private(set) var notificationToken: String?

  public func set(notificationToken: String?) {
    self.notificationToken = notificationToken
  }
}
