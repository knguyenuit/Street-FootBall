//
//  Maker.swift
//  Street-FootBall
//
//  Created by Khanh Nguyen on 7/11/17.
//  Copyright © 2017 Khanh Nguyen. All rights reserved.
//

import Foundation
import GoogleMaps

class Maker: GMSMarker {
    var id: Int?
    var pitch: Pitch?
    
    override init() {
        super.init()
    }
}
