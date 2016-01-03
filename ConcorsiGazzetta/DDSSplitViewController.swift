//
//  DDSSplitViewController.swift
//  ConcorsiGazzetta
//
//  Created by Damiano Di Stefano on 20/10/15.
//  Copyright © 2015 Damiano Di Stefano. All rights reserved.
//

import UIKit

class DDSSplitViewController: UISplitViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.bluGazzettaColor()
        self.preferredDisplayMode = .AllVisible
		self.setNeedsStatusBarAppearanceUpdate()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated)
		self.view.setNeedsDisplay()
		self.view.setNeedsLayout()
	}
	
//	override func viewDidAppear(animated: Bool)
//	{
//		super.viewDidAppear(animated)
//		self.view.setNeedsLayout()
//		self.view.setNeedsDisplay()
//	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
