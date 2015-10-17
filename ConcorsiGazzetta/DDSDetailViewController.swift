//
//  DDSDetailViewController.swift
//  Concorsi_Gazzetta
//
//  Created by Damiano Di Stefano on 27/09/15.
//  Copyright © 2015 Damiano Di Stefano. All rights reserved.
//

import UIKit

class DDSDetailViewController: UIViewController
{

    @IBOutlet weak var detailLabel: UILabel!
    
    var detailItem: String?
    {
        didSet
        {
            // Update the view.
            self.configureView()
        }
    }
    
    private func configureView() -> ()
    {
        // Update the user interface for the detail item.
        if let detail = self.detailItem
        {
            if let label = self.detailLabel
            {
                label.text = detail
            }
        }

    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func printMessage(messagge m: String) -> ()
    {
        print(m)
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
