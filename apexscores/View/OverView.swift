import UIKit
import AVFoundation

final class OverView: UIView {

    @IBOutlet private weak var levelLabel: UILabel!
    @IBOutlet private weak var killLabel: UILabel!
    @IBOutlet private weak var damageLabel: UILabel!
    @IBOutlet private weak var BRRankImageV: UIImageView!
    @IBOutlet private weak var BRRankPointsLabel: UILabel!
    @IBOutlet private weak var BRRankNameLabel: UILabel!
    @IBOutlet private weak var ARRankPointsLabel: UILabel!
    @IBOutlet private weak var ARRankNameLabel: UILabel!
    @IBOutlet private weak var ARRankImageV: UIImageView!
    @IBOutlet private weak var backgroundImageV: UIImageView!
    @IBOutlet private weak var tallImageV: UIImageView!
    @IBOutlet private weak var backgroundStackV: UIStackView!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!{didSet{indicator.startAnimating()}}
    
    
    private var player:AVPlayer?
    
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }

    private func loadNib(){
        let view = Bundle.main.loadNibNamed("OverView", owner: self, options: nil)?.first as! UIView
        view.frame = CGRect(origin: .zero, size: self.bounds.size)
        self.addSubview(view)
    }
    private func playBackgroundVideo(){
        guard
            let path = Bundle.main.path(forResource: "apex0", ofType: ".mp4")else{return}   
        player = AVPlayer(url: URL(fileURLWithPath: path))
        player?.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(origin: .zero, size: backgroundStackV.bounds.size)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.backgroundStackV.layer.insertSublayer(playerLayer, at: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        player?.seek(to: CMTime.zero)
        player?.play()
        self.player?.isMuted = true
    }
    @objc func playerItemDidReachEnd(){
        player?.seek(to: CMTime.zero)
    }
    
    internal func configure(model:ScoreModel){
        DispatchQueue.main.async {
            self.playBackgroundVideo()
            self.indicator.stopAnimating()
            
        }
        self.levelLabel.text = model.level
        self.killLabel.text = model.kill
        self.damageLabel.text = model.damage
        
        
        do{
            guard
                let brRankUrl = URL(string: model.BRRankImage),
                let arRankUrl = URL(string: model.ARRankImage),
                let activeUrl = URL(string: model.activeImage),
                let backgroundUrl = URL(string: model.backgroundImage)
            else{
                return
            }
            let brRankData = try Data(contentsOf: brRankUrl)
            let arRankData = try Data(contentsOf: arRankUrl)
            let activeData = try Data(contentsOf: activeUrl)
            let backgroundData = try Data(contentsOf: backgroundUrl)
            self.BRRankImageV.image = UIImage(data: brRankData)
            self.ARRankImageV.image = UIImage(data: arRankData)
            self.tallImageV.image = UIImage(data: activeData)
            self.backgroundImageV.image = UIImage(data: backgroundData)
        }catch{
            print("could not load AccountImage")
        }
        
        
//        self.killLabel.text = model.kill
//        self.damageLabel.text = model.damage
//        self.killrankLabel.text = rankStRemake(string: model.killRank)
//        self.damagerankLabel.text = rankStRemake(string: model.damageRank)
//        self.levelLabel.text = model.level
//        self.levelrankLabel.text = rankStRemake(string: model.levelRank)
        self.BRRankNameLabel.text = model.BRRankName
        self.BRRankPointsLabel.text = model.BRRankPoint + "pt"
        self.ARRankNameLabel.text = model.ARRankName
        self.ARRankPointsLabel.text = model.ARRankPoint + "pt"
//        self.activeKillLabel.text = unknownScore(score: model.activeKill)
//        self.activeKillrankLabel.text = rankStRemake(string: model.activeKillRank)
//        self.activeDamageLabel.text = unknownScore(score: model.activeDamage)
//        self.activeDamagerankLabel.text = rankStRemake(string: model.activeDamageRank)
    }
    

}
