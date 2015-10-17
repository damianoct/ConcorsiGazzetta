//
//  DDSGazzettaCustomCellWithExpiring.swift
//  ConcorsiGazzetta
//
//  Created by Damiano Di Stefano on 16/10/15.
//  Copyright © 2015 Damiano Di Stefano. All rights reserved.
//

import UIKit

class DDSGazzettaCustomCellWithExpiring: UITableViewCell {

    
    @IBOutlet weak var numberOfExpiringContests: UILabel!
    @IBOutlet weak var numberOfPublication: UILabel!    
    @IBOutlet weak var numberOfContests: UILabel!
    @IBOutlet weak var dateOfPublication: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        backgroundColor = UIColor.clearColor()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
