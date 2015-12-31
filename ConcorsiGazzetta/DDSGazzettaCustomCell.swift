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
	@IBOutlet weak var indicator: CircleView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        //backgroundColor = UIColor.clearColor()
    }

	override func setHighlighted(highlighted: Bool, animated: Bool)
	{
		super.setHighlighted(highlighted, animated: animated)
		if highlighted
		{
			self.indicator.backgroundColor = UIColor.clearColor()
		}
	}
	
	override func setSelected(selected: Bool, animated: Bool)
	{
		super.setSelected(selected, animated: animated)
		//self.contentView.addSubview(indicator)
		if selected
		{
			self.indicator.backgroundColor = UIColor.clearColor()
		}
		// Configure the view for the selected state
	}
	
}
