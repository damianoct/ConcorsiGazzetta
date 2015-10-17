//
//  DDSSplitViewController.swift
//  Concorsi_Gazzetta
//
//  Created by Damiano Di Stefano on 27/09/15.
//  Copyright © 2015 Damiano Di Stefano. All rights reserved.
//

import UIKit

class DDSSplitViewController: UISplitViewController
{
    var detailView: UIViewController?
    
    override func showDetailViewController(vc: UIViewController, sender: AnyObject?)
    {
        let destController = (vc as! UINavigationController).topViewController
        if let child = destController as? DDSDetailViewController
        {
            if let senderController = sender as? UITableViewController
            {
                if collapsed
                {
                    print("push view controller")
                    senderController.navigationController!.pushViewController(child, animated: false) //modificato, era true
                }
                else
                {
                    super.showDetailViewController(vc, sender: sender)
                }
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Status Bar Light
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return .LightContent
    }
}

// MARK: SplitViewController Delegate

extension DDSSplitViewController: UISplitViewControllerDelegate
{
    func targetDisplayModeForActionInSplitViewController(svc: UISplitViewController) -> UISplitViewControllerDisplayMode
    {
        return UISplitViewControllerDisplayMode.Automatic
    }
    
    /*
    The new primary view controller to display onscreen when interface is collapsing.
    
    This function is called only on iPhone 6 Plus and iPhone 6s Plus.
    
    If DetailViewController exists, it's pushed in the master's navigation controller.
    This navigation controller is an item bar of TabBarController which is returned by this function for the new primary view controller in the collapsed envinroment.
    
    */
    
    func primaryViewControllerForCollapsingSplitViewController(splitViewController: UISplitViewController) -> UIViewController?
    {
        if let controller = (splitViewController.viewControllers[splitViewController.viewControllers.count - 1] as! UINavigationController).topViewController as? DDSDetailViewController
        {
            if(controller.detailItem != nil)
            {
                let tabBarController = splitViewController.viewControllers[0] as! UITabBarController
                let selectedNavigationController = tabBarController.viewControllers![tabBarController.selectedIndex] as! UINavigationController
                selectedNavigationController.pushViewController(controller, animated: false)
                
                return tabBarController
            }
        }
        
        return nil
        
    }
    
    /*
    The view controller to use as the primary view controller when interface is expading.
    
    This function is called only on iPhone 6 Plus and iPhone 6s Plus.
    
    If this function returns nil the current primary view controller is used as primary view controller.
    So, if the primary view controller (in the collapsed interface) contains the DetailViewController it is removed from the stack and saved as secondary view of SplitViewController.
    After this stuff the function returns nil so the new primary view controller is the original TabBarController without the DetailViewController.
    
    */
    
    func primaryViewControllerForExpandingSplitViewController(splitViewController: UISplitViewController) -> UIViewController?
    {
        let tabBarController = splitViewController.viewControllers[0] as! UITabBarController
        
        let masterNavControll = tabBarController.viewControllers![tabBarController.selectedIndex] as! UINavigationController
        
        if let _ = masterNavControll.topViewController as? DDSDetailViewController
        {
            detailView = masterNavControll.popViewControllerAnimated(false)
        }
    
        return self.tabBarController
    }
    
    /*
    Asks the delegate to provide the new secondary view controller for the split view interface.
    The function simply returns the new detail controller if detail exists.
    If detail doesn't exist it returns nil.
    
    */
    
    func splitViewController(splitViewController: UISplitViewController, separateSecondaryViewControllerFromPrimaryViewController primaryViewController: UIViewController) -> UIViewController?
    {
        if let detail = detailView
        {
            return DDSDetailNavigationViewController(rootViewController: detail)
        }
        
        return nil
    }
}
