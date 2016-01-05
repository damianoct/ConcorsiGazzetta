//
//  DDSRubbishGazzetteTBC.swift
//  ConcorsiGazzetta
//
//  Created by Damiano Di Stefano on 02/01/16.
//  Copyright © 2016 Damiano Di Stefano. All rights reserved.
//

import UIKit
import CoreData
import MGSwipeTableCell

class DDSRubbishGazzetteTBC: UITableViewController, DDSStoreDelegate
{
	var fetchedResultController : NSFetchedResultsController?
	
	var request : String = ""
	
	override func awakeFromNib()
	{
		super.awakeFromNib()
		fetchedResultController = loadFetchedResultsController()
	}
	
    override func viewDidLoad() -> ()
	{
        super.viewDidLoad()

		/**
			Register Nibs for cell reusing
		**/
		
		tableView.registerNib(UINib(nibName: DDSGazzetteTBC.classicTableCell,
			bundle: NSBundle.mainBundle()),
			forCellReuseIdentifier: DDSGazzetteTBC.classicTableCell)
		
		tableView.registerNib(UINib(nibName: DDSGazzetteTBC.contextExpiringTableCell,
			bundle: NSBundle.mainBundle()),
			forCellReuseIdentifier: DDSGazzetteTBC.contextExpiringTableCell)
		
		self.tableView.dataSource = self
    }
	
	override func viewDidAppear(animated: Bool)
	{
		self.tableView.reloadData()
	}
	
	func onComplete()
	{
		print("Gazzetta Scaricata")
	}
	
	
	private func loadFetchedResultsController() -> NSFetchedResultsController?
	{
		var fetchController : NSFetchedResultsController
		let fetchRequest = NSFetchRequest(entityName: "RubbishGazzetta")
		
		fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "dateOfPublication", ascending: false)]
		
		do
		{
			fetchController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DDSGazzettaStore.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
			fetchController.delegate = self
			try fetchController.performFetch()
		}
		catch
		{
			print("\(error)")
		}
		
		return fetchController
	}
	
    override func didReceiveMemoryWarning() -> ()
	{
        super.didReceiveMemoryWarning()
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
	{
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		if let numberOfRow = fetchedResultController?.fetchedObjects?.count
		{
			return numberOfRow
		}
		
		return 0
    }

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		if let gazzetta = fetchedResultController?.objectAtIndexPath(indexPath) as? DDSRubbishGazzettaItem
		{
			if Int(gazzetta.numberOfExpiringContests) > 0 && DDSSettingsWorker.sharedInstance.showDeadlineContests()
			{
				return tableView.dequeueReusableCellWithIdentifier(DDSGazzetteTBC.contextExpiringTableCell)!
			}
		}
		
		return tableView.dequeueReusableCellWithIdentifier(DDSGazzetteTBC.classicTableCell)!
	}

	override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
	{
		if let gazzetta = fetchedResultController?.objectAtIndexPath(indexPath) as? DDSRubbishGazzettaItem
		{
			if let cell = cell as? DDSGazzettaCustomCellWithExpiring
			{
				//print("Animating: -> \t \(cell.progressDownloadIndicator.isAnimating())")
				if cell.progressDownloadIndicator.isAnimating()
				{
					cell.progressDownloadIndicator.stopAnimating()
					cell.progressDownloadIndicator.startAnimating()
				}
				cell.dateOfPublication.text = NSDateFormatter.getStringFromDateFormatter().stringFromDate(gazzetta.dateOfPublication)
				cell.numberOfPublication.text = "Edizione n. " + String(gazzetta.numberOfPublication)
				cell.numberOfContests.text = String(gazzetta.numberOfContests)
				cell.numberOfExpiringContests.text = String(gazzetta.numberOfExpiringContests)
				cell.delegate = self
			}
			else if let cell = cell as? DDSGazzettaCustomCell
			{
				cell.dateOfPublication.text = NSDateFormatter.getStringFromDateFormatter().stringFromDate(gazzetta.dateOfPublication)
				cell.numberOfPublication.text = "Edizione n. " + String(gazzetta.numberOfPublication)
				cell.numberOfContests.text = String(gazzetta.numberOfContests)
				cell.delegate = self
			}
		}
	}
}

extension DDSRubbishGazzetteTBC : NSFetchedResultsControllerDelegate
{
	private func refreshBadgeNumber() -> ()
	{
		let containerControllerTabBarItem = self.navigationController?.parentViewController?.tabBarItem
		
		if let badgeNumber = containerControllerTabBarItem?.badgeValue
		{
			containerControllerTabBarItem?.badgeValue = String(Int(Int(badgeNumber)! + 1))
		}
		else
		{
			containerControllerTabBarItem?.badgeValue = "1"
		}
	}
	func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) -> ()
	{
		switch(type)
		{
			case .Insert:
					refreshBadgeNumber()
					self.tableView.reloadData()
					break;
			default:
					break;
		}
	}
}

//MARK: MGSwipeTableCellDelegate

extension DDSRubbishGazzetteTBC : MGSwipeTableCellDelegate
{
	private enum CellButton: Int
	{
		case Download = 0
		case Delete = 10
	}
	/**
		Left buttons for cell
	**/
	
	private func leftButtons(forCellAtIndexPath indexOfCell: NSIndexPath) -> [AnyObject]
	{
		let downloadButton = MGSwipeButton(title: "Ripristina",
			icon: UIImage(named: "Cell_Button_G_Download"),
			backgroundColor: UIColor.greenReadColor())
		
		return [downloadButton] as [AnyObject]
	}
	
	/**
		Right buttons for cell
	**/
	
	func rightButtons() -> [AnyObject]
	{
		let deleteButton = MGSwipeButton(title: "Elimina",
			icon: UIImage(named: "CellButton_G_Rubbish"),
			backgroundColor: UIColor.redReadColor())
		
		return [deleteButton] as [AnyObject]
	}
	
	private func indexOfButton(forTappedIndex index: Int, andSwipeDirection direction: MGSwipeDirection) -> Int
	{
		return direction == .LeftToRight ? index : index + 10
	}
	
	func swipeTableCell(cell: MGSwipeTableCell!, tappedButtonAtIndex index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool
	{
		let buttonIndex = indexOfButton(forTappedIndex: index, andSwipeDirection: direction)
		let indexOfCell = self.tableView.indexPathForCell(cell)!
		
		switch(CellButton(rawValue: buttonIndex)!)
		{
			case .Download:
				if cell is DDSGazzettaCustomCell
				{
					(cell as! DDSGazzettaCustomCell).progressDownloadIndicator.hidden = false
					(cell as! DDSGazzettaCustomCell).progressDownloadIndicator.startAnimating()
				}
				else if cell is DDSGazzettaCustomCellWithExpiring
				{
					(cell as! DDSGazzettaCustomCellWithExpiring).progressDownloadIndicator.hidden = false
					(cell as! DDSGazzettaCustomCellWithExpiring).progressDownloadIndicator.startAnimating()
				}
				
				if let gazzetta = fetchedResultController?.objectAtIndexPath(indexOfCell) as? DDSRubbishGazzettaItem
				{
					request = String(gazzetta.dateOfPublication)
					DDSGazzettaStore.sharedInstance.setLoaderDelegate(self)
					DDSGazzettaStore.sharedInstance.downloadGazzetta(withDate: gazzetta.dateOfPublication)
				}
				
				return true
				
			case .Delete:
				print("Tapped Delete")
				return false
		}
		
	}
	
	func swipeTableCell(cell: MGSwipeTableCell!, swipeButtonsForDirection direction: MGSwipeDirection, swipeSettings: MGSwipeSettings!, expansionSettings: MGSwipeExpansionSettings!) -> [AnyObject]!
	{
		swipeSettings.transition = MGSwipeTransition.Static
		
		let indexOfCell = self.tableView.indexPathForCell(cell)!
		
		if direction == MGSwipeDirection.LeftToRight
		{
			return leftButtons(forCellAtIndexPath: indexOfCell)
		}
			
		else
		{
			cell.allowsButtonsWithDifferentWidth = true
			return rightButtons()
		}
	}
}



