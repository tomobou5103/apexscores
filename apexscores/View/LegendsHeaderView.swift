import UIKit

final class LegendsHeaderView: UITableViewHeaderFooterView {
    @IBOutlet private weak var imageV: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    internal func configure(model:LegendsModel){
        self.nameLabel.text = model.name
        do{
            guard
                let imageUrl = URL(string:model.image)
            else{
                return
            }
            let imageData = try Data(contentsOf: imageUrl)
            self.imageV.image = UIImage(data:imageData)
        }catch{
            print("could not load LegendsImage")
        }
    }
}
