import UIKit
import GoogleMobileAds

final class TopViewController: UIViewController{
//MARK: -IBOutlet
    @IBOutlet private weak var bannerView: GADBannerView!
    @IBOutlet private weak var textV: UITextField!{didSet{textV.delegate = self}}
    @IBOutlet private weak var origin: UIButton!
    @IBOutlet private weak var psn: UIButton!
    @IBOutlet private weak var xbox: UIButton!
    @IBOutlet private weak var collectionV: UICollectionView!{didSet{configureCollectionV(c: collectionV)}}
//MARK: -Property
    private var platform:PFSort = .origin
    private var collectionCellId = "SaveTextCollectionViewCell"
    private var backUserNames:[String] = []
    private var udKey = "backUserNames"
    private var segeueId = "Score"
//MARK: -IBActionFunc
    @IBAction func originButton(_ sender: Any) {
        ColorRechange()
        self.origin.tintColor = .systemBlue
        self.platform = .origin
    }
    @IBAction func psnButton(_ sender: Any) {
        ColorRechange()
        self.psn.tintColor = .systemBlue
        self.platform = .ps4
    }
    @IBAction func xboxButton(_ sender: Any) {
        ColorRechange()
        self.xbox.tintColor = .systemBlue
        self.platform = .xbox
    }
//MARK: -Func
    private func configureCollectionV(c:UICollectionView){
        
        c.delegate = self
        c.dataSource = self
        c.register(UINib(nibName: collectionCellId, bundle: nil), forCellWithReuseIdentifier: collectionCellId)
    }
    private func ud(){
        let value = UserDefaults.standard.stringArray(forKey: udKey)
        self.backUserNames = value ?? []
        collectionV.reloadData()
    }
    private func ColorRechange (){
        origin.tintColor = .white
        psn.tintColor = .white
        xbox.tintColor = .white
    }
    private func loadBannerAd() {
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
//MARK: -LyfeSycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ud()
        bannerView.adUnitID = "UnitID"
        bannerView.rootViewController = self
        textV.clearButtonMode = .whileEditing
    }
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
        ud()
        loadBannerAd()
    }
    override func viewWillTransition(to size: CGSize,
                            with coordinator: UIViewControllerTransitionCoordinator) {
      super.viewWillTransition(to:size, with:coordinator)
      coordinator.animate(alongsideTransition: { _ in
        self.loadBannerAd()
      })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let usernameText = self.textV.text else{return}
        let trimSt = usernameText.remove(characterSet: .whitespaces)
        self.backUserNames.insert(trimSt, at: 0)
        UserDefaults.standard.set(self.backUserNames, forKey: udKey)
        if segue.identifier == segeueId{
            self.view.endEditing(true)
            let nextVC = segue.destination as! ScoreViewController
            nextVC.username = trimSt
            nextVC.platform = platform
        }
    }
}
extension TopViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSegue(withIdentifier: segeueId, sender: nil)
        return true
    }
}
extension TopViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.backUserNames.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionV.dequeueReusableCell(withReuseIdentifier: collectionCellId, for: indexPath) as? SaveTextCollectionViewCell
        else{
            return UICollectionViewCell()
        }
        cell.configure(index: indexPath.row, stringArray: self.backUserNames)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.textV.text = backUserNames[indexPath.row]
    }
}
extension TopViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height:CGFloat = collectionV.frame.height / 3
        let width:CGFloat = collectionV.frame.width / 3
        let size = CGSize(width: width, height: height)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}
private extension String{
    func remove(characterSet:CharacterSet)->String{
        return components(separatedBy: characterSet).joined()
    }
}
