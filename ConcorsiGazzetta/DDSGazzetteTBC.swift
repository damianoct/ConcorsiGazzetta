//
//  DDSGazzetteTBC.swift
//  Concorsi_Gazzetta
//
//  Created by Damiano Di Stefano on 27/09/15.
//  Copyright © 2015 Damiano Di Stefano. All rights reserved.
//

import UIKit
import CoreData
import MGSwipeTableCell

enum AlertAction: String
{
    case OrderByExpiringContests = "Concorsi in scadenza"
    case OrderByNumberOfContests = "Concorsi pubblicati"
    case OrderByDateOfPublication = "Data di pubblicazione"
}

enum CellButton: Int
{
	case ToggleRead = 0
	case Favourite = 1
	case Delete = 10
	case Share = 11
}

class DDSGazzetteTBC: UITableViewController
{
    
    static let classicTableCell = "DDSGazzettaCustomCell"
    static let contextExpiringTableCell = "DDSGazzettaCustomCellWithExpiring"
	let tableViewBgImage = "newspaper_background_ingiallito.jpg"
    
    var fetchResultController : NSFetchedResultsController?
    var searchController : UISearchController!
    var searchResultController : DDSSearchTBC!
    
    override func viewDidLoad() -> ()
    {
        super.viewDidLoad()
        
        //setTransparentBackgroundFromImage(named: tableViewBgImage)
		
		/**
			Refresh Control
		**/
		
		self.refreshControl?.tintColor = UIColor.bluGazzettaColor()
		let attrs = [NSForegroundColorAttributeName: UIColor.bluTextColor()]
		let refreshControlText = NSAttributedString(string: "Aggiorno Gazzette...", attributes: attrs)
		self.refreshControl?.attributedTitle = refreshControlText
		self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        NSNotificationCenter.defaultCenter().addObserver(
														 self,
														 selector: "appSettingsDidChange:",
														 name: NSUserDefaultsDidChangeNotification,
														 object: nil)
		
		/**
			Register Nibs for cell reusing
		**/
		
        tableView.registerNib(UINib(nibName: DDSGazzetteTBC.classicTableCell,
									bundle: NSBundle.mainBundle()),
									forCellReuseIdentifier: DDSGazzetteTBC.classicTableCell)
		
        tableView.registerNib(UINib(nibName: DDSGazzetteTBC.contextExpiringTableCell,
									bundle: NSBundle.mainBundle()),
									forCellReuseIdentifier: DDSGazzetteTBC.contextExpiringTableCell)
        
        fetchResultController = loadFetchedResultsController()
    }

    override func didReceiveMemoryWarning() -> ()
    {
        super.didReceiveMemoryWarning()
    }
	
	private func loadFetchedResultsController() -> NSFetchedResultsController?
	{
		var fetchController : NSFetchedResultsController
		let fetchRequest = NSFetchRequest(entityName: "Gazzetta")
		
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
	
	/**
		Left buttons for cell
	**/
	
	private func leftButtons(forCellAtIndexPath indexOfCell: NSIndexPath) -> [AnyObject]
	{
		let specs = readButtonForGazzetta(atIndexPath: indexOfCell)
		
		let toggleReadButton = MGSwipeButton(title: specs.buttonTitle,
											 icon: specs.buttonImage,
											 backgroundColor: specs.buttonColor)
		
		let favouriteButton = MGSwipeButton(title: "",
											icon: UIImage(named: "CellButton_G_Favourite"),
											backgroundColor: UIColor(red: 69.0/255.0, green: 154.0/255.0, blue: 204.0/255.0, alpha: 1.0))
		
		return [toggleReadButton, favouriteButton] as [AnyObject]
	}
	
	/**
		Right buttons for cell
	**/
	
	func rightButtons() -> [AnyObject]
	{
		let shareButton = MGSwipeButton(title: "",
										icon: UIImage(named: "CellButton_G_Share"),
										backgroundColor: UIColor.bluGazzettaColor())
		let deleteButton = MGSwipeButton(title: "Elimina",
										 icon: UIImage(named: "CellButton_G_Rubbish"),
										 backgroundColor: UIColor.redReadColor())
		
		return [deleteButton,shareButton] as [AnyObject]
	}
	
    func appSettingsDidChange(notification: NSNotification) -> ()
    {
        tableView.reloadData()
    }
	
	private func setGazzettaAsRead(atIndexPath index: NSIndexPath) -> ()
	{
		if let gazzetta = fetchResultController?.objectAtIndexPath(index) as? DDSGazzettaItem
		{
			if !gazzetta.read
			{
				gazzetta.read = true
				DDSGazzettaStore.sharedInstance.saveDataObjects()
			}
		}
	}
	
	private func toggleGazzettaReadState(atIndexPath index: NSIndexPath) -> ()
	{
		if let gazzetta = fetchResultController?.objectAtIndexPath(index) as? DDSGazzettaItem
		{
			gazzetta.read = !gazzetta.read
			DDSGazzettaStore.sharedInstance.saveDataObjects()
			self.tableView.reloadData()
		}
	}
	
	private func readButtonForGazzetta(atIndexPath index: NSIndexPath) -> (buttonTitle: String, buttonImage: UIImage, buttonColor: UIColor)
	{
		if let gazzetta = fetchResultController?.objectAtIndexPath(index) as? DDSGazzettaItem
		{
			return !gazzetta.read ? ("",
									 UIImage(named: "CellButton_G_CheckMark")!,
									 UIColor.greenReadColor()) :
									("",
								     UIImage(named: "CellButton_G_UncheckMark")!,
									 UIColor.redReadColor())
		}
		
		return ("", UIImage(named: "CellButton_G_CheckMark")!, UIColor.greenReadColor())
	}
	
    
    //MARK: Design UI Functions
    
    private func setBlurEffect() -> UIView
    {
        let image = UIImage(named: tableViewBgImage)
        tableView.backgroundColor = UIColor(patternImage: image!)
        
        let blur = UIBlurEffect(style: .ExtraLight)
        let blurView = UIVisualEffectView(effect: blur)
        
        return blurView
    }
    
	private func setTransparentBackgroundFromImage(named name: String) -> ()
    {
        let image = UIImage(named: name)
        tableView.backgroundColor = UIColor(patternImage: image!)
        
        let viewWithAlpha = UIView(frame: self.view.bounds)
        viewWithAlpha.backgroundColor = UIColor(white: 0.96, alpha: 0.965)
        
        self.tableView.backgroundView = viewWithAlpha
    }
	
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //return DDSSettingsWorker.sharedInstance.numberOfGazzetteToView().number
		let fetchRequest = NSFetchRequest(entityName: "Gazzetta")

		return DDSGazzettaStore.sharedInstance.managedObjectContext.countForFetchRequest(fetchRequest, error: nil)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if let gazzetta = fetchResultController?.objectAtIndexPath(indexPath) as? DDSGazzettaItem
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
        if let cell = cell as? DDSGazzettaCustomCellWithExpiring
        {
            if let gazzetta = fetchResultController?.objectAtIndexPath(indexPath) as? DDSGazzettaItem
            {
                cell.dateOfPublication.text = NSDateFormatter.getStringFromDateFormatter().stringFromDate(gazzetta.dateOfPublication)
                cell.numberOfPublication.text = "Edizione n. " + String(gazzetta.numberOfPublication)
                cell.numberOfContests.text = String(gazzetta.contests.count)
                cell.numberOfExpiringContests.text = String(gazzetta.numberOfExpiringContests)
				cell.delegate = self
				
				if gazzetta.read
				{
					cell.indicator.hidden = true
				}
				else
				{
					cell.indicator.hidden = false
				}
            }
        }
        else if let cell = cell as? DDSGazzettaCustomCell
        {
            if let gazzetta = fetchResultController?.objectAtIndexPath(indexPath) as? DDSGazzettaItem
            {
                cell.dateOfPublication.text = NSDateFormatter.getStringFromDateFormatter().stringFromDate(gazzetta.dateOfPublication)
                cell.numberOfPublication.text = "Edizione n. " + String(gazzetta.numberOfPublication)
                cell.numberOfContests.text = String(gazzetta.contests.count)
				cell.delegate = self
				if gazzetta.read
				{
					cell.indicator.hidden = true
				}
				else
				{
					cell.indicator.hidden = false
				}
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        performSegueWithIdentifier("segueDetail", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "segueDetail"
		{
			if let index = sender as? NSIndexPath
			{
				if let segueNavController = segue.destinationViewController as? UINavigationController
				{
					if let segueController = segueNavController.topViewController as? DDSDetailViewController
					{
						setGazzettaAsRead(atIndexPath: index)
						segueController.senderController = self
					}
				}
			}
		}
    }
	
	/*override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
	{
		let more = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "")
		{ action, index in
			print("more button tapped")
		}
		more.backgroundColor = UIColor(patternImage: UIImage(named: "Glasses")!)
		
		let favorite = UITableViewRowAction(style: .Normal, title: "Favorite") { action, index in
			print("favorite button tapped")
		}
		favorite.backgroundColor = UIColor.orangeColor()
		
		let share = UITableViewRowAction(style: .Normal, title: "Share") { action, index in
			print("share button tapped")
		}
		share.backgroundColor = UIColor.blueColor()
		
		return [share, favorite, more]
	}
	
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
	{
		// the cells you would like the actions to appear needs to be editable
		return true
	}*/
	
	
	
    //MARK: Ordering Function
	
    private func orderFunction(alertAction: UIAlertAction) -> ()
    {
        var keySort : String
        
        switch(AlertAction(rawValue: alertAction.title!)!)
        {
            case .OrderByExpiringContests: keySort = "numberOfExpiringContests"
            
            case .OrderByNumberOfContests: keySort = "numberOfContests"
            
            default: keySort = "dateOfPublication"
        }
        
        if let fetchController = fetchResultController
        {
            fetchController.fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: keySort, ascending: false )]
            do
            {
                try fetchController.performFetch()
            }
            catch
            {
                print("\(error)")
            }
            
            self.tableView.reloadData()
        }
    }
    
    //MARK: IBAction Ordering
    
    @IBAction func orderButtonPressed(sender: UIBarButtonItem)
    {
        let alertSheetController = UIAlertController(title: "Ordina Gazzette per:", message: nil, preferredStyle: .ActionSheet)
        
        alertSheetController.view.tintColor = UIColor(red: 48.0/255.0, green: 137.0/255.0, blue: 189.0/255.0, alpha: 1)
        
        if DDSSettingsWorker.sharedInstance.showDeadlineContests()
        {
            alertSheetController.addAction(UIAlertAction(title: AlertAction.OrderByExpiringContests.rawValue, style: .Default, handler: orderFunction))
        }
        
        alertSheetController.addAction(UIAlertAction(title: AlertAction.OrderByNumberOfContests.rawValue, style: .Default, handler: orderFunction))
        
        alertSheetController.addAction(UIAlertAction(title: AlertAction.OrderByDateOfPublication.rawValue, style: .Default, handler: orderFunction))
        
        alertSheetController.addAction(UIAlertAction(title: "Annulla", style: .Destructive, handler: nil))
        
        alertSheetController.modalPresentationStyle = .Popover
        
        if let popoverPresentationController = alertSheetController.popoverPresentationController
        {
            popoverPresentationController.barButtonItem = sender
        }
        
        presentViewController(alertSheetController, animated: true, completion: nil)
        
        
        
    }
    //MARK: IBAction Search
    
    @IBAction func searchButtonPressed(sender: UIBarButtonItem)
    {
        let searchResultController = storyboard!.instantiateViewControllerWithIdentifier("searchResultTableView") as! DDSSearchTBC
        
        //creo un oggetto search controller che visualizza i risultato nel searchResultController (una tableview)
        
        let searchController = UISearchController(searchResultsController: searchResultController)
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = searchResultController
        //searchController.searchBar.barTintColor = UIColor(red: 48.0/255.0, green: 137.0/255.0, blue: 189.0/255.0, alpha: 1)
        searchController.searchBar.tintColor = UIColor(red: 24.0/255.0, green: 63.0/255.0, blue: 85.0/255.0, alpha: 1)
        
        presentViewController(searchController, animated: true, completion: nil )
        
    }
    
    //MARK: IBAction Settings

    @IBAction func settingsButtonPressed(sender: UIBarButtonItem)
    {
        let settingsTBC = storyboard!.instantiateViewControllerWithIdentifier("settingsTBC") as! DDSSettingsTBC
        
        self.navigationController!.pushViewController(settingsTBC, animated: true)
        
    }
	
	//MARK: Refresh Control
	
	func handleRefresh(refreshControl: UIRefreshControl)
	{
		if(Reachability.isConnectedToNetwork())
		{
			DDSGazzettaStore.sharedInstance.setLoaderDelegate(self)
			DDSGazzettaStore.sharedInstance.downloadGazzette()
		}
		else
		{
			self.presentViewController(AlertHandler.alertForConnectionFailed(), animated: true)
				{
					refreshControl.endRefreshing()
			}
		}
	}
}

extension DDSGazzetteTBC : MGSwipeTableCellDelegate
{
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
			case .ToggleRead:
								self.toggleGazzettaReadState(atIndexPath: indexOfCell)
								cell.refreshContentView()
								return true
			
			case .Favourite:
								print("Tapped Favourite")
								return false
			
			case .Delete:
								print("Tapped Delete")
								if let gazzetta = fetchResultController?.objectAtIndexPath(indexOfCell) as? DDSGazzettaItem
								{
									DDSGazzettaStore.sharedInstance.managedObjectContext.deleteObject(gazzetta)
									// non fare delete row qui, ma farlo con i metodi del delegato
									// del fetch controller -> NSFetchedResultsControllerDelegate
								}
								return false
			case .Share:
								print("Tapped Share")
								return false
		}

	}
	
	
	func swipeTableCell(cell: MGSwipeTableCell!, swipeButtonsForDirection direction: MGSwipeDirection, swipeSettings: MGSwipeSettings!, expansionSettings: MGSwipeExpansionSettings!) -> [AnyObject]!
	{
		swipeSettings.transition = MGSwipeTransition.Static
		
		let indexOfCell = self.tableView.indexPathForCell(cell)!
		
		if direction == MGSwipeDirection.LeftToRight
		{
			expansionSettings.buttonIndex = 0
			expansionSettings.fillOnTrigger = true
			expansionSettings.threshold = 1.8
			
			return leftButtons(forCellAtIndexPath: indexOfCell)
		}
		
		else
		{
			cell.allowsButtonsWithDifferentWidth = true
			return rightButtons()
		}
	}
}

extension DDSGazzetteTBC : DDSStoreDelegate
{
	func onLoadingComplete()
	{
		print("On Loading Complete -> Aggiorno il fetch controller")
		fetchResultController = loadFetchedResultsController()
		
		if ((self.refreshControl?.refreshing) != nil)
		{
			self.refreshControl?.endRefreshing()
		}
	}
}

extension DDSGazzetteTBC : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        print("tapped")
    }
}

extension DDSGazzetteTBC: UISearchResultsUpdating
{
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        guard searchController.active else { return }
        searchResultController.filterGazzettaString = searchController.searchBar.text
    }
}

extension DDSGazzetteTBC: NSFetchedResultsControllerDelegate
{
	func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) -> ()
	{
		switch(type)
		{
			case .Delete:
							self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Left)
							DDSGazzettaStore.sharedInstance.saveDataObjects()
							break;
			default: break
		}
	}
}
