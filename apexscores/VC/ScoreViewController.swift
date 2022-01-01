import UIKit
import GoogleMobileAds
import HMSegmentedControl

final class ScoreViewController: UIViewController,GADFullScreenContentDelegate{
    
//MARK: -IBOutlet
    @IBOutlet private weak var scrollV: UIScrollView!{didSet{configureScrollView(scroll: scrollV)}}
    @IBOutlet private weak var hmSegment: HMSegmentedControl!{didSet{configureHMSegument(segment: hmSegment)}}
    @IBOutlet private weak var overV: OverView!
    @IBOutlet private weak var legendsV: LegendsView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var userV: UIView!
    @IBOutlet private weak var accountImageV: UIImageView!
    //MARK: -ConfigureIBOutlet
    private func configureHMSegument(segment:HMSegmentedControl){
        segment.sectionTitles = ["Overview","Legends"]
        segment.backgroundColor = .darkGray
        segment.selectionStyle = .box
        segment.selectionIndicatorLocation = .bottom
        segment.selectionIndicatorColor = .systemGreen
        segment.selectedTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HiraginoSans-W7", size: 18)!
        ]
        segment.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font: UIFont(name: "HiraginoSans-W6", size: 16)!
        ]
    }
    private func configureScrollView(scroll:UIScrollView){
        let blockVariable :IndexChangeBlock = {(index:UInt) -> Void in
            let frameSize = scroll.frame.size
            let frame = CGRect(x: frameSize.width * CGFloat(index), y: 0, width: frameSize.width, height: frameSize.height)
            scroll.scrollRectToVisible(frame, animated: true)
        }
        hmSegment.indexChangeBlock = blockVariable
        scroll.delegate = self
        scroll.isPagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.contentInsetAdjustmentBehavior = .always
    }
    private func configureShadowView(){
        userV.shadowEffect(flag: true)
        hmSegment.shadowEffect(flag: true)
        overV.shadowEffect(flag: true)
        legendsV.shadowEffect(flag: true)
    }
//MARK: -Property
    internal var platform:PFSort?
    internal var username = ""
    private var interstitial:GADInterstitialAd?
    private var interstitialUnitId = "ca-app-pub-9808916011504024/9583381053"
//MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadApi(completion: {[weak self]()->Void in
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
    private func loadApi(completion:@escaping()->Void){
        guard let platformSt = self.platform?.returnString()else{return}
        let userData = platformSt + "/" + username
        ScoreAPI.shared.receiveApi(userData: userData, completion:{ model in
            DispatchQueue.main.async {
                if self.setText(model: model){
                    completion()
                }
            }
        })
        
    }
    private func setText(model:ScoreModel)->Bool{
        if model.error.isEmpty{
            self.usernameLabel.text = self.username
            do{
                guard
                    let accountUrl = URL(string:model.accountImage)
                else{
                    return false
                }
                let imageData = try Data(contentsOf: accountUrl)
                self.accountImageV.image = UIImage(data: imageData)
            }catch{
                print("could not load AccountImage")
            }
            overV.configure(model: model)
            legendsV.configure(model:model)
            return true
        }else{
            makeAlert()
            return false
        }
    }
    private func loadInterstitial(completion:@escaping()->Void){
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: interstitialUnitId, request: request, completionHandler: {[self]ad, error in
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
                self.navigationController?.popViewController(animated: true)
                }
            }
        )
        alertControler.addAction(okAction)
        self.present(alertControler, animated: true)
    }
}
//MARK: -Extension
extension ScoreViewController:UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x + 30
        let max = scrollView.frame.maxX
        hmSegment.selectedSegmentIndex = UInt(offset / max)
    }
}
extension UIView{
    internal func shadowEffect(flag:Bool){
        if flag{
            self.layer.cornerRadius = 5
            self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.6
            self.layer.shadowRadius = 4
        }
    }
}
