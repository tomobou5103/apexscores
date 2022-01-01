import UIKit
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            self.permitTarcking()
        }
        return true
    }
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    private func permitTarcking(){
        //Tracking permission
        if #available(iOS 14, *) {
            switch ATTrackingManager.trackingAuthorizationStatus {
            case .authorized:
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                    GADMobileAds.sharedInstance().start(completionHandler: nil)
                })
            case .denied:
                GADMobileAds.sharedInstance().start(completionHandler: nil)
            case .restricted:
                GADMobileAds.sharedInstance().start(completionHandler: nil)
            case .notDetermined:
                showRequestTrackingAuthorizationAlert()
            @unknown default:
                fatalError()
            }
        }else{// iOS14未満
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                print("Allow Tracking")
                print("IDFA: \(ASIdentifierManager.shared().advertisingIdentifier)")
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                    GADMobileAds.sharedInstance().start(completionHandler: nil)
                })
            }else{
                GADMobileAds.sharedInstance().start(completionHandler: nil)
                print("🥺制限")
            }
        }
    }
    //Alert表示
    private func showRequestTrackingAuthorizationAlert() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                switch status {
                case .authorized:
                    print("🎉")
                    //IDFA取得
                    print("IDFA: \(ASIdentifierManager.shared().advertisingIdentifier)")
                case .denied, .restricted, .notDetermined:
                    print("😭")
                @unknown default:
                    fatalError()
                }
            })
        }
    }
}
