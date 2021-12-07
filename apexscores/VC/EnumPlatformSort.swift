import Foundation

enum PFSort {
    
    case origin
    case ps4
    case xbox
    case other
    
    func returnString()->String{
        switch self{
        case .origin:
            return "origin"
        case .ps4:
            return "psn"
        case .xbox:
            return "xbl"
        default:
            return ""
        }
    }
}
