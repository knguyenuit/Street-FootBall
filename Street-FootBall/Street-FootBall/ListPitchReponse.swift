//
//  ListPitchReponse.swift
//  Street-FootBall
//
//  Created by Khanh Nguyen on 6/26/17.
//  Copyright © 2017 Khanh Nguyen. All rights reserved.
//

import Foundation

import Foundation

import UIKit
import ObjectMapper

class ListPitchReponse: NSObject, Mappable {
    
    public var status : Bool?
    public var message : String?
    public var data: [String]?
    
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        data <- map["data"]
    }
    
    override var description : String {
        return "Data list pitch = "
    }
}
