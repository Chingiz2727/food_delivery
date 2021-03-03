public struct UserAuthResponse: Codable {
    let token: Token
    let profile: Profile
    let user: User
}
