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
import BoltsSwift

class Net {
    static var shared = Net()
    var lat = 0.0
    var lng = 0.0
    
    func getPitch() -> Task<Any> {
        let tcs = TaskCompletionSource<Any>()
        print("----------Go to get ALL Pitch")
        let queue = DispatchQueue(label: "com.test.api", qos: .background, attributes: .concurrent)
        
        Alamofire.request( "http://fooco.esy.es//public/api/pitch/get.php?type=list&by=all" , method: .post, parameters: nil, encoding: URLEncoding.default, headers : nil).log(level: .all, options: [.onlyDebug, .jsonPrettyPrint, .includeSeparator])
            .responseJSON(queue: queue) { (response) in
                
                
                if let statusCode = response.response?.statusCode {
                    print("STATUS CODE \(statusCode)")
                }
                
                switch response.result {
                case .failure(let error) :
                    print(error)
                    tcs.set(error: error)
                case .success(let responseObject) :
                    if let apiResponse = Mapper<APIResponseArray<Pitch>>().map(JSONObject: responseObject) {
                        apiResponse.datas?.forEach({ (result) in
                            Pitch.listPitch.append(result)
                        })
                        tcs.set(result: Pitch.listPitch)
                    }
                }
        }
        return tcs.task
    }
    
    func getPitchOwner(id: Int) -> Task<Any> {
        let tcs = TaskCompletionSource<Any>()

        Alamofire.request( "http://fooco.esy.es/public/api/owner/get.php" , method: .post, parameters: ["id":id], encoding: URLEncoding.default, headers : nil).log(level: .all, options: [.onlyDebug, .jsonPrettyPrint, .includeSeparator])
            .responseJSON { (response) in
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
                if let statusCode = response.response?.statusCode {
                    print("STATUS CODE \(statusCode)")
                }
                
                switch response.result {
                case .failure(let error) :
                    print(error)
                    tcs.set(error: error)
                case .success(let responseObject) :
                    print("Nguyen \(responseObject)")
                    if let apiResponse = Mapper<APIResponse<PitchOwnerReponse>>().map(JSONObject: responseObject) {
                        apiResponse.data?.pitchOwner.forEach({ (results) in
                            Pitch.listPitch.append(results)
                        })
                        tcs.set(result: Pitch.listPitch)
                    }
                }
        }
        return tcs.task
    }
    
    func getPitchByDistrict(id: Int = 2) -> Task<Any> {

        print("----------Go to get PITCH BY DISTRICT")
        let tcs = TaskCompletionSource<Any>()
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
                    tcs.set(error: error)
                case .success(let responseObject) :
                    if let apiResponse = Mapper<APIResponseArray<Pitch>>().map(JSONObject: responseObject) {
                        apiResponse.datas?.forEach({ (result) in
                            Pitch.listPitchByDistrict.append(result)
                        })
                        tcs.set(result: Pitch.listPitchByDistrict)
                    }
                }
        }
        return tcs.task
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
    
    func getCoordinate(location: String) -> Task<Any> {

        let tcs = TaskCompletionSource<Any>()
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
                            let coordinate = Location(lat: self.lat, lng: self.lng)
                           tcs.set(result: coordinate)
                        }
                    })
                }
            }
        }

        return tcs.task
    }

    
//    func getPitch(success: @escaping ([Pitch]) -> Void){
//        let activityData = ActivityData()
//        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
//        
//
//        
//        Alamofire.request( "http://fooco.esy.es//public/api/pitch/get.php?type=list&by=all" , method: .post, parameters: nil, encoding: URLEncoding.default, headers : nil).log(level: .all, options: [.onlyDebug, .jsonPrettyPrint, .includeSeparator])
//            .responseJSON { (response) in
//                
//                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
//                
//                if let statusCode = response.response?.statusCode {
//                    print("STATUS CODE \(statusCode)")
//                }
//                
//                switch response.result {
//                case .failure(let error) :
//                    print(error)
//                case .success(let responseObject) :
//                    print("Nguyen \(responseObject)")
//                    if let apiResponse = Mapper<APIResponseArray<Pitch>>().map(JSONObject: responseObject) {
//                        apiResponse.datas?.forEach({ (result) in
//                            Pitch.listPitch.append(result)
//                            
//                        })
//                        success(Pitch.listPitch)
//                    }
//                }
//        }
//    }
    
//    func getPitchOwner(id: Int, success: @escaping ([Pitch]) -> Void){
//        let activityData = ActivityData()
//        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
//        
//        Alamofire.request( "http://fooco.esy.es/public/api/owner/get.php" , method: .post, parameters: ["id":id], encoding: URLEncoding.default, headers : nil).log(level: .all, options: [.onlyDebug, .jsonPrettyPrint, .includeSeparator])
//            .responseJSON { (response) in
//                
//                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
//                
//                if let statusCode = response.response?.statusCode {
//                    print("STATUS CODE \(statusCode)")
//                }
//                
//                switch response.result {
//                case .failure(let error) :
//                    print(error)
//                case .success(let responseObject) :
//                    print("Nguyen \(responseObject)")
//                    if let apiResponse = Mapper<APIResponse<PitchOwnerReponse>>().map(JSONObject: responseObject) {
//                        apiResponse.data?.pitchOwner.forEach({ (results) in
//                            Pitch.listPitch.append(results)
//                        })
//                        success(Pitch.listPitch)
//                    }
//                }
//        }
//    }
    
    

    
//    func getPitchByDistrict(id: Int = 2, success: @escaping ([Pitch]) -> Void){
//        let activityData = ActivityData()
//        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
//        
//        let param = ["by": "name_location", "location_id": "\(id)", "type":"list"]
//        
//        Alamofire.request( "http://fooco.esy.es/public/api/pitch/get.php" , method: .post, parameters: param, encoding: URLEncoding.default, headers : nil).log(level: .all, options: [.onlyDebug, .jsonPrettyPrint, .includeSeparator])
//            .responseJSON { (response) in
//                
//                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
//                
//                if let statusCode = response.response?.statusCode {
//                    print("STATUS CODE \(statusCode)")
//                }
//                
//                switch response.result {
//                case .failure(let error) :
//                    print(error)
//                case .success(let responseObject) :
//                    if let apiResponse = Mapper<APIResponseArray<Pitch>>().map(JSONObject: responseObject) {
//                        apiResponse.datas?.forEach({ (result) in
//                            Pitch.listPitchByDistrict.append(result)
//                        })
//                        success(Pitch.listPitchByDistrict)
//                    }
//                }
//        }
//    }

    


    

    
    
}


