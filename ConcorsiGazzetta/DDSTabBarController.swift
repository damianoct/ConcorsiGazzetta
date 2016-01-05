//
//  DDSTabBarController.swift
//  ConcorsiGazzetta
//
//  Created by Damiano Di Stefano on 03/01/16.
//  Copyright © 2016 Damiano Di Stefano. All rights reserved.
//

import UIKit

class DDSTabBarController: UITabBarController
{

    override func viewDidLoad() -> ()
	{
        super.viewDidLoad()
		//self.tabBar.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() -> ()
	{
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension DDSTabBarController : UITabBarControllerDelegate
{
	override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem)
	{
		print(item.badgeValue)
		//refresh badge item
		if let _ = item.badgeValue
		{
			item.badgeValue = nil
		}
	}
}
