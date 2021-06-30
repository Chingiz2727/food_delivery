enum MapApiTarget: ApiTarget {
    case getPolylines

    var version: ApiVersion {
        return .custom("")
    }
    
    var servicePath: String {
        return ""
    }
    
    var path: String {
        return "delivery/area/byCity"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: [String : Any]? {
        return ["cityId":176]
    }
    
    var stubData: Any {
        return [:]
    }
    
    
}
