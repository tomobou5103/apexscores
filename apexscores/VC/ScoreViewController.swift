import UIKit
import GoogleMobileAds
import HMSegmentedControl

final class ScoreViewController: UIViewController,GADFullScreenContentDelegate{
    
//MARK: -IBOutlet
    @IBOutlet private weak var scrollV: UIScrollView!{didSet{configureScrollView(scroll: scrollV)}}
    @IBOutlet private weak var hmSegment: HMSegmentedControl!{didSet{configureHMSegument(segment: hmSegment)}}
    @IBOutlet private weak var overV: OverView!
    @IBOutlet private weak var LegendsV: LegendsView!
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
//MARK: -Property
    internal var platform:PFSort?
    internal var username = ""
    private var interstitial:GADInterstitialAd?
//MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        shadow(name: self.userV)
        shadow(name: self.hmSegment)
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
        if model.error.isEmpty{
            self.usernameLabel.text = self.username
            do{
                guard
                    let accountUrl = URL(string:model.accountImage)
                else{
                    return
                }
                let imageData = try Data(contentsOf: accountUrl)
                self.accountImageV.image = UIImage(data: imageData)
            }catch{
                print("could not load AccountImage")
            }
            overV.configure(model: model)
            LegendsV.configure(model:model)
        }else{
            makeAlert()
        }
    }
    private func loadInterstitial(completion:@escaping()->Void){
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: "UnitID", request: request, completionHandler: {[self]ad, error in
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
