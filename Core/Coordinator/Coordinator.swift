public protocol Coordinator: class {
  var router: Routable { get }
  
  func start()
}
