import UIKit
import Alamofire
import SwiftyJSON

class NextViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var damagerankLabel: UILabel!
    @IBOutlet weak var killrankLabel: UILabel!
    @IBOutlet weak var levelrankLabel: UILabel!
    @IBOutlet weak var userV: UIView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var killLabel: UILabel!
    @IBOutlet weak var damageLabel: UILabel!
    @IBOutlet weak var accountImageV: UIImageView!
    @IBOutlet weak var rankImageV: UIImageView!
    @IBOutlet weak var rankPointLabel: UILabel!
    @IBOutlet weak var rankNameLabel: UILabel!
    @IBOutlet weak var mainLabel: UIView!
    @IBOutlet weak var rankLabel: UIView!
    @IBOutlet weak var activeImageV: UIImageView!
    @IBOutlet weak var activeV: UIView!
    @IBOutlet weak var topPageButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    //Topページに返すアクション
    @IBAction func topPage(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "home")as!ViewController
        mainViewController.modalPresentationStyle = .fullScreen
        self.present(mainViewController,animated: true,completion: nil)
    }
    //ヘルプページに返すボタン
    @IBAction func helpPageButton(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let finalViewController = storyBoard.instantiateViewController(withIdentifier: "final")as!FinalViewController
        self.present(finalViewController,animated: true,completion: nil)
    }
    //アクティブキャラのLabel
    @IBOutlet weak var activeLevelLabel: UILabel!
    @IBOutlet weak var activeLevelrankLabel: UILabel!
    @IBOutlet weak var activeKillLabel: UILabel!
    @IBOutlet weak var activeKillrankLabel: UILabel!
    @IBOutlet weak var activeDamageLabel: UILabel!
    @IBOutlet weak var activeDamagerankLabel: UILabel!
    
    var platform = ""
    var username = ""
    let url = "https://public-api.tracker.gg/v2/apex/standard/profile/"
    let url2 = "?TRN-Api-Key=a5281189-f169-4f7a-9a5d-803cfeb1aeff"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HttpChange()
        shadow(name: self.userV)
        shadow(name: self.mainLabel)
        shadow(name: self.rankLabel)
        shadow(name: self.activeV)
        shadow(name: self.activeImageV)
        shadow(name: self.topPageButton)
        shadow(name: self.helpButton)

    }
    
    
    
    func shadow(name:UIView){
        name.layer.cornerRadius = 5
        name.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        // 影の色
        name.layer.shadowColor = UIColor.black.cgColor
        // 影の濃さ
        name.layer.shadowOpacity = 0.6
        // 影をぼかし
        name.layer.shadowRadius = 4
    }
    
    func HttpChange(){
        print(platform)
        
        if platform == "PC"{
            platform = "origin"
        }
        if platform == "PS4"{
            platform = "psn"
        }
        if platform == "XBOX"{
            platform = "xbl"
        }
        
        let nurl = url + platform + "/" + username + url2
        print(nurl)

        
        AF.request(nurl).responseJSON() { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                if json["errors"][0]["code"] == "CollectorResultStatus::NotFound" {
                    let alertControler = UIAlertController(title: "ユーザー情報が取得できませんでした。", message: "プラットフォームまたはユーザー名を確認し、再び実行して下さい。", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Top", style: .default, handler: {(action: UIAlertAction!) in
                        //アラートが消えるのと画面遷移が重ならないように0.5秒後に画面遷移するようにしてる
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        //0.5秒後に実行したい処理
                            let storyboard: UIStoryboard = self.storyboard!
                            let nextView = storyboard.instantiateViewController(withIdentifier: "home")
                            nextView.modalPresentationStyle = .fullScreen
                            self.present(nextView, animated: true, completion: nil)
                            }
                        }
                    )
                    alertControler.addAction(okAction)
                    //アラートを表示する
                    self.present(alertControler, animated: true)
                }else{
                
                //アカウントイメージ取得
                let acimage =  json["data"]["platformInfo"]["avatarUrl"].stringValue
                let url = URL(string: acimage)
                do {
                      let data = try Data(contentsOf: url!)
                      let image = UIImage(data: data)
                    self.accountImageV.image = image

                 }catch let err {
                      print("Error : \(err.localizedDescription)")
                 }
                //ランクイメージ取得
                
                let rankimage =  json["data"]["segments"][0]["stats"]["rankScore"]["metadata"]["iconUrl"].stringValue
                let rankurl = URL(string: rankimage)
                do {
                      let data = try Data(contentsOf: rankurl!)
                      let image = UIImage(data: data)
                    self.rankImageV.image = image

                 }catch let err {
                      print("Error : \(err.localizedDescription)")
                 }
                //アクティブキャライメージ
                
                let activeimage =  json["data"]["segments"][1]["metadata"]["tallImageUrl"].stringValue
                let activeurl = URL(string: activeimage)
                    

                do {
                    let data = try Data(contentsOf: activeurl!)
                      let image = UIImage(data: data)
                    self.activeImageV.image = image
                    self.activeImageV.contentMode = .scaleAspectFit

                 }catch let err {
                      print("Error : \(err.localizedDescription)")
                 }

                var killnum: String = json["data"]["segments"][0]["stats"]["kills"]["displayValue"].stringValue
                if killnum == "" {
                    killnum = "unknown"
                }
                var killrank: String = json["data"]["segments"][0]["stats"]["kills"]["rank"].stringValue
                var damage: String = json["data"]["segments"][0]["stats"]["damage"]["displayValue"].stringValue
                if damage == ""{
                    damage = "unknown"
                }
                var damagerank:String = json["data"]["segments"][0]["stats"]["damage"]["rank"].stringValue
                let level: String = json["data"]["segments"][0]["stats"]["level"]["value"].stringValue
                var levelrank: String = json["data"]["segments"][0]["stats"]["level"]["rank"].stringValue
                
                let rankname: String = json["data"]["segments"][0]["stats"]["rankScore"]["metadata"]["rankName"].stringValue
                
                let rankpoint: String = json["data"]["segments"][0]["stats"]["rankScore"]["displayValue"].stringValue
                
                //taking active score
                var akill: String = json["data"]["segments"][1]["stats"]["kills"]["displayValue"].stringValue
                var akillrank: String = json["data"]["segments"][1]["stats"]["kills"]["rank"].stringValue
                var adamage: String = json["data"]["segments"][1]["stats"]["damage"]["displayValue"].stringValue
                var adamagerank:String = json["data"]["segments"][1]["stats"]["damage"]["rank"].stringValue
                if akill == "" {
                    akill = "unknown"
                }
                if adamage == ""{
                    adamage = "unknown"
                }
                
                if levelrank != ""{
                    levelrank = "#" + levelrank
                }else{
                    levelrank = "　"
                }
                if killrank != ""{
                    killrank = "#" + killrank
                }
                if damagerank != ""{
                    damagerank = "#" + damagerank
                }
                if adamagerank != ""{
                    adamagerank = "#" + adamagerank
                }else{
                    adamagerank = "　"
                }
                if akillrank != ""{
                    akillrank = "#" + akillrank
                }else{
                    akillrank = "　"
                }
                
                self.killLabel.text = killnum
                self.damageLabel.text = damage
                self.usernameLabel.text = self.username
                self.levelLabel.text = level
                self.rankNameLabel.text = rankname
                self.rankPointLabel.text = "\(rankpoint) pt"
                self.levelrankLabel.text = levelrank
                self.killrankLabel.text = killrank
                self.damagerankLabel.text = damagerank
            
                // push active score
                self.activeKillLabel.text = akill
                self.activeKillrankLabel.text = akillrank
                self.activeLevelLabel.text = level
                self.activeLevelrankLabel.text = levelrank
                self.activeDamageLabel.text = adamage
                self.activeDamagerankLabel.text = adamagerank
            
                }
            case .failure(let error):
                print(error)
            }
        
    }
 }
}
