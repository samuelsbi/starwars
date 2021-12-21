import Foundation

struct ItemDescription {
    var label: String
    var value: Value
    
    enum Value {
        case label(String)
        case url(title: String, link: String)
    }
}

