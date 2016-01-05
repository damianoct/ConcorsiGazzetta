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
import CoreData

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
		(i metodi originali cambiano il background alla cella e quindi nascondono la UIView)
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

extension DDSGazzettaCustomCell : DDSGazzettaCell
{
	func configureCell(forGazzetta gazzetta: DDSGazzettaItem)
	{
		dateOfPublication.text = NSDateFormatter.getStringFromDateFormatter().stringFromDate(gazzetta.dateOfPublication)
		numberOfPublication.text = "Edizione n. " + String(gazzetta.numberOfPublication)
		numberOfContests.text = String(gazzetta.contests.count)
		
		if gazzetta.read
		{
			indicator.hidden = true
		}
		else
		{
			indicator.hidden = false
		}
	}
	
	func configureCell(forRubbishGazzetta gazzetta: DDSRubbishGazzettaItem)
	{
		
	}
}