import Foundation
import Alamofire
import SwiftyJSON

final class ScoreAPI:NSObject{
    static let shared = ScoreAPI()
    private override init(){}
    
    private let header = "https://public-api.tracker.gg/v2/apex/standard/profile/"
    private let footer = "?TRN-Api-Key=a5281189-f169-4f7a-9a5d-803cfeb1aeff"
    
    func receiveApi(userData:String,completion:@escaping(ScoreModel)->Void){
        let urlSt = header + userData + footer
        print(urlSt)
        AF.request(urlSt).responseJSON { response in
                  switch response.result {
                  case .success(let value):
                      let json = JSON(value)
                      let model = ScoreModel(json: json)
                      completion(model)
                  case .failure(let error):
                      print(error)
                  }
        }
    }
}
