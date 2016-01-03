//
//  DDSGazzettaCustomCell.swift
//  iOSConcorsiGazzetta
//
//  Created by Damiano Di Stefano on 07/10/15.
//  Copyright © 2015 Damiano Di Stefano. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import MRProgress

class DDSGazzettaCustomCell: MGSwipeTableCell
{
    
	@IBOutlet weak var progressDownloadIndicator: MRActivityIndicatorView!
    @IBOutlet weak var dateOfPublication: UILabel!
    @IBOutlet weak var numberOfPublication: UILabel!
    @IBOutlet weak var numberOfContests: UILabel!
	@IBOutlet weak var indicator: UIView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
		indicator.hidden = true
		progressDownloadIndicator.tintColor = UIColor.bluGazzettaColor()
		progressDownloadIndicator.hidden = true
        //backgroundColor = UIColor.clearColor()
    }
	
	/**
		Override delle funzioni setHighlighted e setSelected per non "spazzare via"
		UIView della cell quando quest'ultima è selezionata
	**/

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
