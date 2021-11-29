import UIKit
import GoogleMobileAds
import SystemConfiguration

final class NextViewController: UIViewController,GADFullScreenContentDelegate{
    
//MARK: -IBOutlet
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var damagerankLabel: UILabel!
    @IBOutlet private weak var killrankLabel: UILabel!
    @IBOutlet private weak var levelrankLabel: UILabel!
    @IBOutlet private weak var userV: UIView!
    @IBOutlet private weak var levelLabel: UILabel!
    @IBOutlet private weak var killLabel: UILabel!
    @IBOutlet private weak var damageLabel: UILabel!
    @IBOutlet private weak var accountImageV: UIImageView!
    @IBOutlet private weak var rankImageV: UIImageView!
    @IBOutlet private weak var rankPointLabel: UILabel!
    @IBOutlet private weak var rankNameLabel: UILabel!
    @IBOutlet private weak var mainLabel: UIView!
    @IBOutlet private weak var rankLabel: UIView!
    @IBOutlet private weak var activeImageV: UIImageView!
    @IBOutlet private weak var activeV: UIView!
    @IBOutlet private weak var topPageButton: UIButton!
    @IBOutlet private weak var helpButton: UIButton!
    @IBOutlet private weak var activeLevelLabel: UILabel!
    @IBOutlet private weak var activeLevelrankLabel: UILabel!
    @IBOutlet private weak var activeKillLabel: UILabel!
    @IBOutlet private weak var activeKillrankLabel: UILabel!
    @IBOutlet private weak var activeDamageLabel: UILabel!
    @IBOutlet private weak var activeDamagerankLabel: UILabel!
//MARK: -Property
    internal var platform:PFSort?
    internal var username = ""
    private var interstitial:GADInterstitialAd?
//MARK: -IBAction
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
//MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        shadow(name: self.userV)
        shadow(name: self.mainLabel)
        shadow(name: self.rankLabel)
        shadow(name: self.activeV)
        shadow(name: self.activeImageV)
        shadow(name: self.topPageButton)
        shadow(name: self.helpButton)
        
        
        
        HttpChange(completion: {[weak self]()->Void in
            self?.loadInterstitial(completion: {[weak self]()->Void in
                if self?.interstitial != nil{
                    self?.interstitial?.present(fromRootViewController: self!)
                }else{
                    print("ad wasnt ready")
                }
            })
        })
    }
//MARK: -Func
    private func shadow(name:UIView){
        name.layer.cornerRadius = 5
        name.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        name.layer.shadowColor = UIColor.black.cgColor
        name.layer.shadowOpacity = 0.6
        name.layer.shadowRadius = 4
    }
    private func loadInterstitial(completion:@escaping()->Void){
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: "ID", request: request, completionHandler: {[self]ad, error in
            if let error = error{
                print("could not load interstitial ad with eroor-\(error.localizedDescription)")
                return
            }
            interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
            completion()
        })
    }
    private func makeAlert(){
        let alertControler = UIAlertController(title: "ユーザー情報が取得できませんでした。", message: "プラットフォームまたはユーザー名を確認し、再び実行して下さい。", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Top", style: .default, handler: {(action: UIAlertAction!) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let storyboard: UIStoryboard = self.storyboard!
                let nextView = storyboard.instantiateViewController(withIdentifier: "home")
                nextView.modalPresentationStyle = .fullScreen
                self.present(nextView, animated: true, completion: nil)
                }
            }
        )
        alertControler.addAction(okAction)
        self.present(alertControler, animated: true)
    }
    private func HttpChange(completion:@escaping()->Void){
        guard let platformSt = self.platform?.returnString()else{return}
        let userData = platformSt + "/" + username
        ScoreAPI.shared.receiveApi(userData: userData, completion:{ model in
            DispatchQueue.main.async {
                self.setText(model: model)
                
            }
        })
    }
    private func setText(model:ScoreModel){
        if model.error == ""{
            self.usernameLabel.text = self.username
            do{
                guard
                    let accountUrl = URL(string:model.accountImage),
                    let rankUrl = URL(string: model.rankImage),
                    let activeUrl = URL(string: model.activeImage)
                else{
                    return
                }
                let imageData = try Data(contentsOf: accountUrl)
                let rankData = try Data(contentsOf: rankUrl)
                let activeData = try Data(contentsOf: activeUrl)
                self.accountImageV.image = UIImage(data: imageData)
                self.rankImageV.image = UIImage(data: rankData)
                self.activeImageV.image = UIImage(data: activeData)
            }catch{
                print("could not load AccountImage")
            }
            self.killLabel.text = model.kill
            self.damageLabel.text = model.damage
            self.killrankLabel.text = rankStRemake(string: model.killRank)
            self.damagerankLabel.text = rankStRemake(string: model.damageRank)
            self.levelLabel.text = model.level
            self.levelrankLabel.text = rankStRemake(string: model.levelRank)
            self.rankNameLabel.text = model.rankName
            self.rankPointLabel.text = model.rankPoint
            self.activeKillLabel.text = unknownScore(score: model.activeKill)
            self.activeKillrankLabel.text = rankStRemake(string: model.activeKillRank)
            self.activeDamageLabel.text = unknownScore(score: model.activeDamage)
            self.activeDamagerankLabel.text = rankStRemake(string: model.activeDamageRank)
        }
    }
    private func rankStRemake(string:String)->String{
        let res = string == "" ? string : "#" + string
        return res
    }
    private func unknownScore(score:String)->String{
        if score == ""{
            return "Set Tracker"
        }else{
            return score
        }
    }
}
