import Foundation
import SwiftyJSON

struct ScoreModel{

    //Could not found the account error
    internal let error:String
    //Account image
    internal let accountImage:String
    //Account Rank image
    internal let BRRankImage:String
    internal let ARRankImage:String
    internal let backgroundImage:String
    //Rank Score
    internal let BRRankName:String
    internal let BRRankPoint:String
    internal let ARRankName:String
    internal let ARRankPoint:String
    //Active image
    internal let activeImage:String
    //Score
    internal let kill:String
    internal let killRank:String
    internal let damage:String
    internal let damageRank:String
    internal let level:String
    internal let levelRank:String
    //ActiveScore
    internal let activeKill:String
    internal let activeKillRank:String
    internal let activeDamage:String
    internal let activeDamageRank:String
    
    init(json:JSON){
        self.error = json["errors"][0]["code"].stringValue
        self.accountImage = json["data"]["platformInfo"]["avatarUrl"].stringValue
        self.BRRankImage = json["data"]["segments"][0]["stats"]["rankScore"]["metadata"]["iconUrl"].stringValue
        self.ARRankImage = json["data"]["segments"][0]["stats"]["arenaRankScore"]["metadata"]["iconUrl"].stringValue
        self.backgroundImage = json["data"]["segments"][1]["metadata"]["bgImageUrl"].stringValue
        self.activeImage = json["data"]["segments"][1]["metadata"]["tallImageUrl"].stringValue
        self.kill = json["data"]["segments"][0]["stats"]["kills"]["displayValue"].stringValue
        self.killRank = json["data"]["segments"][0]["stats"]["kills"]["rank"].stringValue
        self.damage = json["data"]["segments"][0]["stats"]["damage"]["displayValue"].stringValue
        self.damageRank = json["data"]["segments"][0]["stats"]["damage"]["rank"].stringValue
        self.level = json["data"]["segments"][0]["stats"]["level"]["value"].stringValue
        self.levelRank = json["data"]["segments"][0]["stats"]["level"]["rank"].stringValue
        self.BRRankName = json["data"]["segments"][0]["stats"]["rankScore"]["metadata"]["rankName"].stringValue
        self.BRRankPoint = json["data"]["segments"][0]["stats"]["rankScore"]["displayValue"].stringValue
        self.ARRankName = json["data"]["segments"][0]["stats"]["arenaRankScore"]["metadata"]["rankName"].stringValue
        self.ARRankPoint = json["data"]["segments"][0]["stats"]["arenaRankScore"]["displayValue"].stringValue
        self.activeKill = json["data"]["segments"][1]["stats"]["kills"]["displayValue"].stringValue
        self.activeKillRank = json["data"]["segments"][1]["stats"]["kills"]["rank"].stringValue
        self.activeDamage = json["data"]["segments"][1]["stats"]["damage"]["displayValue"].stringValue
        self.activeDamageRank = json["data"]["segments"][1]["stats"]["damage"]["rank"].stringValue
    }
}
