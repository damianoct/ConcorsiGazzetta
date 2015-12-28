//
//  DDSGazzetteTBC.swift
//  Concorsi_Gazzetta
//
//  Created by Damiano Di Stefano on 27/09/15.
//  Copyright © 2015 Damiano Di Stefano. All rights reserved.
//

import UIKit
import CoreData

enum AlertAction: String
{
    case OrderByExpiringContests = "Concorsi in scadenza"
    case OrderByNumberOfContests = "Concorsi pubblicati"
    case OrderByDateOfPublication = "Data di pubblicazione"
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
		
		self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        NSNotificationCenter.defaultCenter().addObserver(
														 self,
														 selector: "appSettingsDidChange:",
														 name: NSUserDefaultsDidChangeNotification,
														 object: nil)
        tableView.registerNib(UINib(
									nibName: DDSGazzetteTBC.classicTableCell,
									bundle: NSBundle.mainBundle()),
									forCellReuseIdentifier: DDSGazzetteTBC.classicTableCell)
        tableView.registerNib(UINib(
									nibName: DDSGazzetteTBC.contextExpiringTableCell,
									bundle: NSBundle.mainBundle()),
									forCellReuseIdentifier: DDSGazzetteTBC.contextExpiringTableCell)
        
        fetchResultController = loadFetchedResultsController()
    }

    override func didReceiveMemoryWarning() -> ()
    {
        super.didReceiveMemoryWarning()
    }
    
    func appSettingsDidChange(notification: NSNotification) -> ()
    {
        tableView.reloadData()
    }
	
	func handleRefresh(refreshControl: UIRefreshControl)
	{
		print("Refreshing table...");
		refreshControl.endRefreshing()
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
    
    private func loadFetchedResultsController() -> NSFetchedResultsController?
    {
        var fetchController : NSFetchedResultsController
        let fetchRequest = NSFetchRequest(entityName: "Gazzetta")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "dateOfPublication", ascending: false)]
        
        do
        {
            fetchController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DDSGazzettaStore.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Gazzetta Cache")
            try fetchController.performFetch()
        }
        catch
        {
            print("\(error)")
            return nil
        }
        
        return fetchController
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return DDSSettingsWorker.sharedInstance.numberOfGazzetteToView().number
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
            }
        }
        else if let cell = cell as? DDSGazzettaCustomCell
        {
            if let gazzetta = fetchResultController?.objectAtIndexPath(indexPath) as? DDSGazzettaItem
            {
                cell.dateOfPublication.text = NSDateFormatter.getStringFromDateFormatter().stringFromDate(gazzetta.dateOfPublication)
                cell.numberOfPublication.text = "Edizione n. " + String(gazzetta.numberOfPublication)
                cell.numberOfContests.text = String(gazzetta.contests.count)
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        performSegueWithIdentifier("segueDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
    }
    
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
        searchController.searchBar.barTintColor = UIColor(red: 48.0/255.0, green: 137.0/255.0, blue: 189.0/255.0, alpha: 1)
        searchController.searchBar.tintColor = UIColor(red: 24.0/255.0, green: 63.0/255.0, blue: 85.0/255.0, alpha: 1)
        
        presentViewController(searchController, animated: true, completion: nil )
        
    }
    
    //MARK: IBAction Settings

    @IBAction func settingsButtonPressed(sender: UIBarButtonItem)
    {
        let settingsTBC = storyboard!.instantiateViewControllerWithIdentifier("settingsTBC") as! DDSSettingsTBC
        
        self.navigationController!.pushViewController(settingsTBC, animated: true)
        
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
