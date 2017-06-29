//
//  ListPitchTableViewCell.swift
//  Street-FootBall
//
//  Created by Khanh Nguyen on 6/21/17.
//  Copyright © 2017 Khanh Nguyen. All rights reserved.
//

import UIKit

class ListPitchTableViewCell: UITableViewCell {

    @IBOutlet weak var ivPitchAvatar: UIImageView!
    @IBOutlet weak var lbPitchName: UILabel!
    @IBOutlet weak var lbPitchPhoneNumber: UILabel!
    @IBOutlet weak var lbPitchCount: UILabel!
    @IBOutlet weak var lbPitchAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
