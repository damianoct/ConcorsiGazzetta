//
//  DDSSearchTBC.swift
//  ConcorsiGazzetta
//
//  Created by Damiano Di Stefano on 12/10/15.
//  Copyright © 2015 Damiano Di Stefano. All rights reserved.
//

import UIKit
import CoreData

private struct Gazzetta
{
    var numberOfPublication: String
    var dateOfPublication: String
    var numberOfContests: String
    var numberOfExpiringContests: String
    
    var month : String
    var day : String
    var year : String
    
    init(gazzettaItem g: DDSGazzettaItem)
    {
        self.numberOfPublication = String(g.numberOfPublication)
        self.dateOfPublication = NSDateFormatter.getStringFromDateFormatter().stringFromDate(g.dateOfPublication)
        self.numberOfContests = String(g.contests.count)
        self.numberOfExpiringContests = String(g.numberOfExpiringContests)
        let dateArray = dateOfPublication.characters.split {$0 == " "}.map(String.init)
        day = dateArray[0]; month = dateArray[1]; year = dateArray[2]
    }
}

class DDSSearchTBC: UITableViewController
{
    private var visibleResults: [Gazzetta]!
    private var fullGazzette : [Gazzetta] = [Gazzetta]()
    {
        didSet
        {
            visibleResults = fullGazzette
        }
    }
    
    var filterGazzettaString: String? = nil
        {
        didSet
        {
            if filterGazzettaString == nil || filterGazzettaString!.isEmpty
            {
                visibleResults = fullGazzette
            }
            else
            {
                let filterPredicateContains = NSPredicate(format: "self contains[c] %@", argumentArray: [filterGazzettaString!])
                let filterPredicateBegins = NSPredicate(format: "self BEGINSWITH[cd] %@", argumentArray: [filterGazzettaString!])
                
                visibleResults = fullGazzette.filter
                {
                        filterPredicateBegins.evaluateWithObject($0.day) ||
						filterPredicateBegins.evaluateWithObject($0.month) ||
						filterPredicateBegins.evaluateWithObject($0.year) ||
						filterPredicateContains.evaluateWithObject($0.numberOfPublication) ||
						filterPredicateContains.evaluateWithObject($0.numberOfContests)
                }
            }
            tableView.reloadData()
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        setBackgroundTransparentWithImage()
        tableView.registerNib(UINib(nibName: DDSGazzetteTBC.classicTableCell, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: DDSGazzetteTBC.classicTableCell)
        tableView.registerNib(UINib(nibName: DDSGazzetteTBC.contextExpiringTableCell, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: DDSGazzetteTBC.contextExpiringTableCell)
        
        if let fetchedGazzette = loadFetchedGazzette()
        {
            fullGazzette = fetchedGazzette
        }
    }
    
    private func setBackgroundTransparentWithImage()
    {
        let image = UIImage(named: "newspaper_background_ingiallito.jpg")
        tableView.backgroundColor = UIColor(patternImage: image!)
        
        let viewWithAlpha = UIView(frame: self.view.bounds)
        viewWithAlpha.backgroundColor = UIColor(white: 0.96, alpha: 0.965)
        
        tableView.backgroundView = viewWithAlpha
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    private func loadFetchedGazzette() -> [Gazzetta]?
    {
        func fetchGazzetteData() -> [DDSGazzettaItem]?
        {
            let fetchRequest = NSFetchRequest(entityName: "Gazzetta")
            fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "dateOfPublication", ascending: false)]
            do
            {
                let fetchResults = try DDSGazzettaStore.sharedInstance.getManagedObjectContext().executeFetchRequest(fetchRequest) as! [DDSGazzettaItem]
                return fetchResults
            }
            catch
            {
                return nil
            }
        }
        
        func gazzette(fromGazzetteItems g: () -> [DDSGazzettaItem]?) -> [Gazzetta]?
        {
            var gazzette = [Gazzetta]()
            
            if let gazzetteItems = g()
            {
                for item in gazzetteItems
                {
                    gazzette.append(Gazzetta(gazzettaItem: item))
                }
                return gazzette
            }
            else
            {
                return nil
            }
        }
        
        return gazzette(fromGazzetteItems: fetchGazzetteData)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return visibleResults.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if Int(visibleResults[indexPath.row].numberOfExpiringContests) > 0 && DDSSettingsWorker.sharedInstance.showDeadlineContests()
        {
            return tableView.dequeueReusableCellWithIdentifier(DDSGazzetteTBC.contextExpiringTableCell)!
        }
        else
        {
            return tableView.dequeueReusableCellWithIdentifier(DDSGazzetteTBC.classicTableCell)!
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if let cell = cell as? DDSGazzettaCustomCellWithExpiring
        {

            cell.dateOfPublication.text = visibleResults[indexPath.row].dateOfPublication
            cell.numberOfPublication.text = "Edizione n. " + visibleResults[indexPath.row].numberOfPublication
            cell.numberOfContests.text = visibleResults[indexPath.row].numberOfContests
            cell.numberOfExpiringContests.text = visibleResults[indexPath.row].numberOfExpiringContests
            
        }
        else if let cell = cell as? DDSGazzettaCustomCell
        {
            cell.dateOfPublication.text = visibleResults[indexPath.row].dateOfPublication
            cell.numberOfPublication.text = "Edizione n. " + visibleResults[indexPath.row].numberOfPublication
            cell.numberOfContests.text = visibleResults[indexPath.row].numberOfContests
        }
    }
}

extension DDSSearchTBC: UISearchResultsUpdating
{
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        guard searchController.active else { return } //vedere meglio GUARD
        
        filterGazzettaString = searchController.searchBar.text
    }
}