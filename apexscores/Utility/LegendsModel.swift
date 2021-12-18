import Foundation
import SwiftyJSON

struct LegendsModel{
    internal let name:String
    internal let image:String
    internal var metadataDic:[String:String] = [:]
    private var count = 0
    init(json:JSON,index:Int){
        self.name = json["metadata"]["name"].stringValue
        self.image = json["metadata"]["portraitImageUrl"].stringValue
        
        json["stats"].forEach{(_,data)in
            let name = data["displayName"].stringValue
            let score = data["displayValue"].stringValue
            self.metadataDic["name\(count)"] = name
            self.metadataDic["score\(count)"] = score
            count += 1
        }
        print("LEGENDSMODELLEGENDSMODELLEGENDSMODELLEGENDSMODELLEGENDSMODELLEGENDSMODELLEGENDSMODELLEGENDSMODEL")
        print(self)
    }
}
