//
//  User.swift
//  Street-FootBall
//
//  Created by Khanh Nguyen on 6/22/17.
//  Copyright © 2017 Khanh Nguyen. All rights reserved.
//

import Foundation
import ObjectMapper

class User : NSObject, Mappable {
    var id: Int?
    var name : String?
    var email : String?
    
    override init() {
        super.init()
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["userId"]
        name <- map["userName"]
        email <- map["userEmail"]
    }
    
    
}
