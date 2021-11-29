import UIKit

final class FinalViewController: UIViewController {
    @IBAction func toppageButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "home")as!ViewController
        mainViewController.modalPresentationStyle = .fullScreen
        self.present(mainViewController,animated: true,completion: nil)
    }
}
