//
//  DDSGazzettaCustomCell.swift
//  iOSConcorsiGazzetta
//
//  Created by Damiano Di Stefano on 07/10/15.
//  Copyright © 2015 Damiano Di Stefano. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class DDSGazzettaCustomCell: MGSwipeTableCell
{
    
    @IBOutlet weak var dateOfPublication: UILabel!
    @IBOutlet weak var numberOfPublication: UILabel!
    @IBOutlet weak var numberOfContests: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        //backgroundColor = UIColor.clearColor()
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
