//
//  DDSDetailNavigationViewController.swift
//  Concorsi_Gazzetta
//
//  Created by Damiano Di Stefano on 29/09/15.
//  Copyright © 2015 Damiano Di Stefano. All rights reserved.
//

import UIKit

class DDSDetailNavigationViewController: UINavigationController
{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundColor = UIColor(red: 48.0/255.0, green: 137.0/255.0, blue: 189.0/255.0, alpha: 1.0)
        
        navigationBar.barTintColor = backgroundColor
        navigationBar.tintColor = UIColor.whiteColor()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
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
