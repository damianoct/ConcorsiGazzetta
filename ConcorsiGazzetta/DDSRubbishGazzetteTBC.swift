//
//  DDSRubbishGazzetteTBC.swift
//  ConcorsiGazzetta
//
//  Created by Damiano Di Stefano on 02/01/16.
//  Copyright © 2016 Damiano Di Stefano. All rights reserved.
//

import UIKit
import CoreData

class DDSRubbishGazzetteTBC: UITableViewController
{

	var fetchedResultController : NSFetchedResultsController?
	
	override func awakeFromNib()
	{
		fetchedResultController = loadFetchedResultsController()
	}
	
    override func viewDidLoad() -> ()
	{
        super.viewDidLoad()
    }
	
	private func loadFetchedResultsController() -> NSFetchedResultsController?
	{
		var fetchController : NSFetchedResultsController
		let fetchRequest = NSFetchRequest(entityName: "RubbishGazzetta")
		
		fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "dateOfPublication", ascending: false)]
		
		do
		{
			fetchController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DDSGazzettaStore.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Gazzetta Cache")
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
	{
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
					break;
			default:
					break;
		}
	}
}
