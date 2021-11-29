import Foundation
import SwiftyJSON

struct ScoreModel{

    //Could not found the account error
    internal let error:String
    //Account image
    internal let accountImage:String
    //Account rank image
    internal let rankImage:String
    //Active image
    internal let activeImage:String
    //Score
    internal let kill:String
    internal let killRank:String
    internal let damage:String
    internal let damageRank:String
    internal let level:String
    internal let levelRank:String
    //RankScore
    internal let rankName:String
    internal let rankPoint:String
    //ActiveScore
    internal let activeKill:String
    internal let activeKillRank:String
    internal let activeDamage:String
    internal let activeDamageRank:String
    
    init(json:JSON){
        self.error = json["errors"][0]["code"].stringValue
        self.accountImage = json["data"]["platformInfo"]["avatarUrl"].stringValue
        self.rankImage = json["data"]["segments"][0]["stats"]["rankScore"]["metadata"]["iconUrl"].stringValue
        self.activeImage = json["data"]["segments"][1]["metadata"]["tallImageUrl"].stringValue
        self.kill = json["data"]["segments"][0]["stats"]["kills"]["displayValue"].stringValue
        self.killRank = json["data"]["segments"][0]["stats"]["kills"]["rank"].stringValue
        self.damage = json["data"]["segments"][0]["stats"]["damage"]["displayValue"].stringValue
        self.damageRank = json["data"]["segments"][0]["stats"]["damage"]["rank"].stringValue
        self.level = json["data"]["segments"][0]["stats"]["level"]["value"].stringValue
        self.levelRank = json["data"]["segments"][0]["stats"]["level"]["rank"].stringValue
        self.rankName = json["data"]["segments"][0]["stats"]["rankScore"]["metadata"]["rankName"].stringValue
        self.rankPoint = json["data"]["segments"][0]["stats"]["rankScore"]["displayValue"].stringValue
        self.activeKill = json["data"]["segments"][1]["stats"]["kills"]["displayValue"].stringValue
        self.activeKillRank = json["data"]["segments"][1]["stats"]["kills"]["rank"].stringValue
        self.activeDamage = json["data"]["segments"][1]["stats"]["damage"]["displayValue"].stringValue
        self.activeDamageRank = json["data"]["segments"][1]["stats"]["damage"]["rank"].stringValue
    }
}
