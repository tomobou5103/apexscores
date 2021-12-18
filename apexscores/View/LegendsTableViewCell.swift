import UIKit

final class LegendsTableViewCell: UITableViewCell {

//MARK: -IBOutlet
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    //MARK: -Function
    internal func configure(model:LegendsModel,index:Int){
        if model.metadataDic["name\(index)"] == "Zipline: Times used by Squad"{
            self.nameLabel.text = "Zipline:Times used"
        }else if model.metadataDic["name\(index)"] == "Grapple: Travel Distance"{
            self.nameLabel.text = "Grapple:Distance"
        }else{
            self.nameLabel.text = model.metadataDic["name\(index)"]
        }
        self.scoreLabel.text = model.metadataDic["score\(index)"]
        
        if index % 2 == 1{
            self.backgroundColor = .gray
        }else{
            self.backgroundColor = .darkGray
        }
    }

}
