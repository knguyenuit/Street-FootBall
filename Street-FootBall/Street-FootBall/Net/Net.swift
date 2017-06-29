//
//  File.swift
//  Street-FootBall
//
//  Created by Khanh Nguyen on 6/26/17.
//  Copyright © 2017 Khanh Nguyen. All rights reserved.
//

import Foundation
import NVActivityIndicatorView
import ObjectMapper
import AlamofireActivityLogger
import Alamofire
import AFNetworking

class Net{
    static var shared = Net()
    var lat = 0.0
    var lng = 0.0
    
    func getPitch(success: @escaping ([Pitch]) -> Void){
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        Alamofire.request( "http://fooco.esy.es//public/api/pitch/get.php?type=list&by=all" , method: .post, parameters: nil, encoding: URLEncoding.default, headers : nil).log(level: .all, options: [.onlyDebug, .jsonPrettyPrint, .includeSeparator])
            .responseJSON { (response) in
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
                if let statusCode = response.response?.statusCode {
                    print("STATUS CODE \(statusCode)")
                }
                
                switch response.result {
                case .failure(let error) :
                    print(error)
                case .success(let responseObject) :
                    print("Nguyen \(responseObject)")
                    if let apiResponse = Mapper<APIResponseArray<Pitch>>().map(JSONObject: responseObject) {
                        apiResponse.datas?.forEach({ (result) in
                            Pitch.listPitch.append(result)
                            
                        })
                        success(Pitch.listPitch)
                    }
                }
        }
    }
    
    func getPitchOwner(id: Int, success: @escaping ([Pitch]) -> Void){
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        Alamofire.request( "http://fooco.esy.es/public/api/owner/get.php" , method: .post, parameters: ["id":id], encoding: URLEncoding.default, headers : nil).log(level: .all, options: [.onlyDebug, .jsonPrettyPrint, .includeSeparator])
            .responseJSON { (response) in
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
                if let statusCode = response.response?.statusCode {
                    print("STATUS CODE \(statusCode)")
                }
                
                switch response.result {
                case .failure(let error) :
                    print(error)
                case .success(let responseObject) :
                    print("Nguyen \(responseObject)")
                    if let apiResponse = Mapper<APIResponse<PitchOwnerReponse>>().map(JSONObject: responseObject) {
                        apiResponse.data?.pitchOwner.forEach({ (results) in
                            Pitch.listPitch.append(results)
                        })
                        success(Pitch.listPitch)
                    }
                }
        }
    }
    
    func getPitchByDistrict(id: Int = 2, success: @escaping ([Pitch]) -> Void){
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        let param = ["by": "name_location", "location_id": "\(id)", "type":"list"]
        
        Alamofire.request( "http://fooco.esy.es/public/api/pitch/get.php" , method: .post, parameters: param, encoding: URLEncoding.default, headers : nil).log(level: .all, options: [.onlyDebug, .jsonPrettyPrint, .includeSeparator])
            .responseJSON { (response) in
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
                if let statusCode = response.response?.statusCode {
                    print("STATUS CODE \(statusCode)")
                }
                
                switch response.result {
                case .failure(let error) :
                    print(error)
                case .success(let responseObject) :
                    if let apiResponse = Mapper<APIResponseArray<Pitch>>().map(JSONObject: responseObject) {
                        apiResponse.datas?.forEach({ (result) in
                            Pitch.listPitchByDistrict.append(result)
                        })
                        success(Pitch.listPitchByDistrict)
                    }
                }
        }
    }

    func getCoordinateLocation(location: String, success: @escaping (Double, Double) -> Void){
        let temp1 = location.replacingOccurrences(of: "Đ", with: "D")
        let temp2 = temp1.replacingOccurrences(of: "đ", with: "d")
        let oldString = temp2.folding(options: .diacriticInsensitive, locale: .current)
        let newString = oldString.replacingOccurrences(of: " ", with: "+")
        Alamofire.request("https://maps.googleapis.com/maps/api/geocode/json", method: .get, parameters: ["address": newString, "key": "AIzaSyCaNIA8p6P0fRDHDXP9FGUUX7h8Iwqbayg"], encoding: URLEncoding.default, headers: nil).responseJSON { (reponse) in
            switch reponse.result {
            case .failure(let error) :
                print(error)
            case .success(let responseObject) :
                
                if let apiResponse = Mapper<APIResponseArray<MapReponse>>().map(JSONObject: responseObject) {
                    apiResponse.result?.forEach({ (results) in
                        if results.geometry != nil {
                       self.lat = (results.geometry?.location?.lat!)!
                       self.lng = (results.geometry?.location?.lng!)!
                        success(self.lat, self.lng)
                    }
                })
            }
        }
    }
}
    
    func getCoordinateLocation(location: String) {
        let temp1 = location.replacingOccurrences(of: "Đ", with: "D")
        let temp2 = temp1.replacingOccurrences(of: "đ", with: "d")
        let oldString = temp2.folding(options: .diacriticInsensitive, locale: .current)
        let newString = oldString.replacingOccurrences(of: " ", with: "+")
        Alamofire.request("https://maps.googleapis.com/maps/api/geocode/json", method: .get, parameters: ["address": newString, "key": "AIzaSyCaNIA8p6P0fRDHDXP9FGUUX7h8Iwqbayg"], encoding: URLEncoding.default, headers: nil).responseJSON { (reponse) in
            switch reponse.result {
            case .failure(let error) :
                print(error)
            case .success(let responseObject) :
                print(responseObject)
                if let apiResponse = Mapper<APIResponseArray<MapReponse>>().map(JSONObject: responseObject) {
                    apiResponse.result?.forEach({ (results) in
                        print(results.geometry?.location?.lat)
                        
                    })
                    
                    
                    }
            
            }
        }
    }
//
//    func setBaseImageUrl(size:Int) -> String{
//        return self.baseImageUrl + "\(size)"
//    }
    
    
}

class NetMap: AFHTTPSessionManager {
    var lat: Double = 0.0
    var long: Double = 0.0
    static var share = NetMap()
    
    func getMovies(success: @escaping ([Pitch]) -> Void){
        self.get("http://fooco.esy.es//public/api/pitch/get.php?type=list&by=all", parameters: nil, progress: nil, success: { (task, data) in
            if let data = data as? NSDictionary{
                if let pitch = data.value(forKey: "data") as? [NSDictionary]{
                    pitch.forEach({ (result) in
                        let pitch = Pitch()
                        pitch.pitchName = result.value(forKey: "pitchName")! as! String
                        pitch.pitchLocation = result.value(forKey: "pitchLocation")! as! String
                        pitch.pitchPhoneNumber = result.value(forKey: "pitchPhone")! as! String
                        pitch.pitchImageURL = result.value(forKey: "pitchAvatar")! as! String
                        Pitch.listPitch.append(pitch)
                    })
                    success(Pitch.listPitch)
                }
            }
        }) { (task, error) in
            print(error.localizedDescription)
        }
    }

    
    func getCoordinateLocation(location: String, success: @escaping (Double, Double) -> Void){
        let temp1 = location.replacingOccurrences(of: "Đ", with: "D")
        let temp2 = temp1.replacingOccurrences(of: "đ", with: "d")
        let oldString = temp2.folding(options: .diacriticInsensitive, locale: .current)
        let newString = oldString.replacingOccurrences(of: " ", with: "+")
        self.get("https://maps.googleapis.com/maps/api/geocode/json?address="+"\(newString)"+"&key=AIzaSyBuUNcAJhyL2a2bUqmTYl760Kzk-usxeMg", parameters: nil, progress: nil, success: { (task, data) in
            if let data = data as? NSDictionary{
                print(data)
                if let pitch = data.value(forKey: "results") as? NSArray{
                    pitch.forEach({ (result) in
                        if let geometry = (result as! NSDictionary).value(forKey: "geometry") as? NSDictionary{
                            if let location = geometry.value(forKey: "location") as? NSDictionary{
                                self.lat = location.value(forKey: "lat") as! Double
                                self.long = location.value(forKey: "lng") as! Double
                                success(Double(self.lat),self.long)
                            }
                        }
                    })
                }
            }
        }) { (task, error) in
            print(error.localizedDescription)
        }
    }
    
}
