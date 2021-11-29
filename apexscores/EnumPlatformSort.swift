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


//if platform == "PC"{
//    self.platform = "origin"
//}
//if platform == "PS4"{
//    self.platform = "psn"
//}
//if platform == "XBOX"{
//    self.platform = "xbl"
//}
