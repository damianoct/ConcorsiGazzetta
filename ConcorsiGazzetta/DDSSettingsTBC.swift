//
//  DDSSettingsTBC.swift
//  Concorsi_Gazzetta
//
//  Created by Damiano Di Stefano on 23/09/15.
//  Copyright © 2015 Damiano Di Stefano. All rights reserved.
//

import UIKit

class DDSSettingsTBC: UITableViewController
{
    override func viewDidLoad() -> ()
    {
        super.viewDidLoad()
        
        //tableView.backgroundColor = UIColor.clearColor() // -> da usare se lo sfondo del NavController è fisso
        
        //setBlurEffect()
        setBackgroundTransparentWithImage()
    }

    override func didReceiveMemoryWarning() -> ()
    {
        super.didReceiveMemoryWarning()
    }
    
    private func setBackgroundTransparentWithImage()
    {
        let image = UIImage(named: "newspaper_background_ingiallito.jpg")
        tableView.backgroundColor = UIColor(patternImage: image!)
        
        let viewWithAlpha = UIView(frame: self.view.bounds)
        viewWithAlpha.backgroundColor = UIColor(white: 0.96, alpha: 0.965)
        
        tableView.backgroundView = viewWithAlpha
    }
    
    private func setBlurEffect()
    {
        //tableView.layer.contents = UIImage(named: "newspaper_background_ingiallito.jpg")?.CGImage // per mantenere l'aspect fit dell'immagine di background... si apprezza meno il Blur
        
        let image = UIImage(named: "newspaper_background_ingiallito.jpg")
        tableView.backgroundColor = UIColor(patternImage: image!)
        
        let blur = UIBlurEffect(style: .ExtraLight)
        let blurView = UIVisualEffectView(effect: blur)
        
        tableView.backgroundView = blurView
        
        //tableView.separatorEffect = UIVibrancyEffect(forBlurEffect: blur!)
    }
    
    func refreshNumberOfGazzetteCell() -> ()
    {
        let cellIndex = NSIndexPath(forRow: 0, inSection: 0)
        let cell = super.tableView(tableView, cellForRowAtIndexPath: cellIndex)
        cell.detailTextLabel?.text = String(DDSSettingsWorker.sharedInstance.numberOfGazzetteToView().number) + " gazzette"
    }
    
    private func setResetCell(cell: UITableViewCell) -> ()
    {
        if(DDSSettingsWorker.sharedInstance.trafficSize() == 0)
        {
            cell.textLabel?.textColor = UIColor.grayColor()
        }
        else
        {
            cell.selectionStyle = .Gray
        }
    }
    
    private func resetTrafficSizeCell()
    {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1))
        DDSSettingsWorker.sharedInstance.resetTrafficSize()
        cell.detailTextLabel?.text = DDSSettingsWorker.sharedInstance.trafficSizeReadable()
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)

        if(indexPath.section == 2 && indexPath.row == 0)
        {
            resetTrafficSizeCell()
            setResetCell(cell)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            cell.userInteractionEnabled = false
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //static cell
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        cell.backgroundColor = UIColor.clearColor()
        
        if(indexPath.section == 0 && indexPath.row == 0)
        {
            cell.imageView!.transform = CGAffineTransformMakeScale(0.7, 0.7)
            cell.detailTextLabel?.text = String(DDSSettingsWorker.sharedInstance.numberOfGazzetteToView().number) + " gazzette"
        }
        
        else if(indexPath.section == 1 && indexPath.row == 0)
        {
            cell.imageView!.transform = CGAffineTransformMakeScale(0.7, 0.7)
            cell.detailTextLabel?.text = DDSSettingsWorker.sharedInstance.trafficSizeReadable()
            cell.selectionStyle = .None
        }
        
        else if(indexPath.section == 2 && indexPath.row == 0)
        {
            setResetCell(cell)
        }
                
        return cell
    }
}
