import UIKit
import Alamofire
import SwiftyJSON
import GoogleMobileAds

class ViewController: UIViewController, UIPickerViewDelegate,UITextFieldDelegate{
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var textV: UITextField!
    @IBOutlet weak var origin: UIButton!
    @IBOutlet weak var psn: UIButton!
    @IBOutlet weak var xbox: UIButton!

    @IBAction func originButton(_ sender: Any) {
        ColorRechange()
        self.origin.tintColor = .systemBlue
        ViewController.self.platform = "PC"
    }
    @IBAction func psnButton(_ sender: Any) {
        ColorRechange()
        self.psn.tintColor = .systemBlue
        ViewController.self.platform = "PS4"
    }
    @IBAction func xboxButton(_ sender: Any) {
        ColorRechange()
        self.xbox.tintColor = .systemBlue
        ViewController.self.platform = "XBOX"
    }
    func ColorRechange (){
        origin.tintColor = .white
        psn.tintColor = .white
        xbox.tintColor = .white
    }
    // 文字列の前後の空白を取り除く
    func trim(string: String) -> String {
        return string.trimmingCharacters(in: .whitespaces)
    }
    static var username = ""
    static var platform = "PC"
    
    override func viewDidLoad() {
    
        bannerView.adUnitID = "ca-app-pub-9808916011504024/5668730667"
        bannerView.rootViewController = self
        textV.clearButtonMode = .whileEditing
        super.viewDidLoad()
        textV.delegate = self
        ViewController.self.platform = "PC"
    }
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      loadBannerAd()
    }

    override func viewWillTransition(to size: CGSize,
                            with coordinator: UIViewControllerTransitionCoordinator) {
      super.viewWillTransition(to:size, with:coordinator)
      coordinator.animate(alongsideTransition: { _ in
        self.loadBannerAd()
      })
    }
    func loadBannerAd() {
      let frame = { () -> CGRect in
        if #available(iOS 11.0, *) {
          return view.frame.inset(by: view.safeAreaInsets)
        } else {
          return view.frame
        }
      }()
      let viewWidth = frame.size.width
      bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
      bannerView.load(GADRequest())
    }
    //テキストフィールドでリターンが押されたときに通知され起動するメソッド
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ViewController.username = trim(string: textV.text ?? "")
        self.view.endEditing(true)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier:"NextViewController" ) as! NextViewController
        nextViewController.username = ViewController.username
        nextViewController.platform = ViewController.platform
        // 遷移先をFullScreenで表示する
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController,animated: true,completion: nil)
        return true
    }
    

}
