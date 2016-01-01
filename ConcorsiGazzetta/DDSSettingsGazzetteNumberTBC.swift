//
//  DDSSettingsTableViewController.swift
//  Concorsi_Gazzetta
//
//  Created by Damiano Di Stefano on 22/09/15.
//  Copyright © 2015 Damiano Di Stefano. All rights reserved.
//

import UIKit

class DDSSettingsGazzetteNumberTBC: UITableViewController
{

    override func viewDidLoad() -> ()
    {
        super.viewDidLoad()
        //setBackgroundTransparentWithImage()
    }

    override func didReceiveMemoryWarning() -> ()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Design UI Functions
    
    private func setBlurEffect()
    {
        let image = UIImage(named: "newspaper_background_ingiallito.jpg")
        tableView.backgroundColor = UIColor(patternImage: image!)
        
        let blur = UIBlurEffect(style: .ExtraLight)
        let blurView = UIVisualEffectView(effect: blur)
        
        tableView.backgroundView = blurView
    }
    
    private func setBackgroundTransparentWithImage()
    {
        let image = UIImage(named: "newspaper_background_ingiallito.jpg")
        tableView.backgroundColor = UIColor(patternImage: image!)
        
        let viewWithAlpha = UIView(frame: self.view.bounds)
        viewWithAlpha.backgroundColor = UIColor(white: 0.96, alpha: 0.965)
        
        tableView.backgroundView = viewWithAlpha
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) -> ()
    {
        if(indexPath != DDSSettingsWorker.sharedInstance.numberOfGazzetteToView().index)
        {
            refreshCheckmark(atNewIndex: indexPath)
			
			DDSSettingsWorker.sharedInstance.setNumberOfGazzetteToView(fromIndexPath: indexPath)
			
            (self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2] as? DDSSettingsTBC)?.refreshNumberOfGazzetteCell()
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //static tableview!
        
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
                
        if(indexPath == DDSSettingsWorker.sharedInstance.numberOfGazzetteToView().index)
        {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        return cell
    }
    
    private func refreshCheckmark(atNewIndex index: NSIndexPath) -> ()
    {
        let oldCell = tableView.cellForRowAtIndexPath(DDSSettingsWorker.sharedInstance.numberOfGazzetteToView().index)
        
        let newCell = tableView.cellForRowAtIndexPath(index)
        
        oldCell?.accessoryType = UITableViewCellAccessoryType.None
        
        newCell?.accessoryType = UITableViewCellAccessoryType.Checkmark
    }
}
