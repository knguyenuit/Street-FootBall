//
//  Pitch.swift
//  Street-FootBall
//
//  Created by Khanh Nguyen on 6/26/17.
//  Copyright © 2017 Khanh Nguyen. All rights reserved.
//	

import Foundation
import ObjectMapper

class Pitch : NSObject, Mappable {
    var id: String?
    var name : String?
    var phone : String?
    var avatar : String?
    var location: PitchLocation?
    
    var pitchName = ""
    var pitchLocation = ""
    var pitchPhoneNumber = ""
    var pitchImageURL = ""
    
    static var listPitch = [Pitch]()
    static var listPitchOwner = [Pitch]()
    static var listPitchByDistrict = [Pitch]()
    
    override init() {
        super.init()
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["pitchID"]
        name <- map["pitchName"]
        phone <- map["pitchPhone"]
        avatar <- map["pitchAvatar"]
        location <- map["pitchLocation"]
    }
    
    
}

class PitchLocation : NSObject, Mappable {
    
    var address = ""
    var geoLocation: GeoLocation?
    
    override init() {
        super.init()
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        address <- map["address"]
        geoLocation <- map["geoLocation"]
    }
    
    
}

class GeoLocation: NSObject, Mappable {
    
    public var lng : Double?
    public var lat: Double?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        lat <- map["lat"]
        lng <- map["lang"]
        
    }
    
}


