public enum PaginationState {

  case idle
  case loading
  case error(Error)

  public var isIdle: Bool {
    if case .idle = self {
      return true
    }
    return false
  }

  public var isLoading: Bool {
    if case .loading = self {
      return true
    }
    return false
  }

  public var isError: Bool {
    if case .error = self {
      return true
    }
    return false
  }
}

extension PaginationState: Equatable {

  public static func == (lhs: PaginationState, rhs: PaginationState) -> Bool {
    switch (lhs, rhs) {
    case (.idle, .idle):
      return true
    case (.loading, .loading):
      return true
    default:
      return false
    }
  }
}
