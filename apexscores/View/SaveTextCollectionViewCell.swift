import UIKit

final class SaveTextCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    internal func configure(index:Int,stringArray:[String]){
        self.nameLabel.text = stringArray[index]
    }

}
