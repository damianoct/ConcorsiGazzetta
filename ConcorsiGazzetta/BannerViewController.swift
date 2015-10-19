//
//  ViewController.swift
//  ConcorsiGazzetta
//
//  Created by Damiano Di Stefano on 11/10/15.
//  Copyright © 2015 Damiano Di Stefano. All rights reserved.
//

import UIKit
import iAd

class BannerViewController: UIViewController, ADBannerViewDelegate
{
    var bannerView: ADBannerView?
    var contentController : UIViewController?
    
    override func viewDidLoad()
    {
        bannerView = BannerViewManager.shareInstance.bannerView
        contentController = self.childViewControllers[0]
        BannerViewManager.shareInstance.addBannerViewController(bannerViewController: self)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        view.addSubview(bannerView!)
    }
    
    override func viewDidLayoutSubviews()
    {
        var contentFrame = self.view.bounds
        var bannerFrame = CGRectZero;
        
        bannerFrame.size = self.bannerView!.sizeThatFits(contentFrame.size)
            
        if self.bannerView!.bannerLoaded
        {
            contentFrame.size.height -= bannerFrame.size.height
            bannerFrame.origin.y = contentFrame.size.height
        }
            
        else
        {
            bannerFrame.origin.y = 2 * contentFrame.size.height
        }
        
        self.contentController!.view.frame = contentFrame
        
//        bannerView!.frame = bannerFrame
//        view.addSubview(bannerView!)
//        view.layoutSubviews()

        if let _ = view.window
        {
            if isViewLoaded()
            {
                bannerView!.frame = bannerFrame
                view.addSubview(bannerView!)
                view.layoutSubviews()
            }
        }
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation
    {
        return contentController!.preferredInterfaceOrientationForPresentation()
    }
    
    func updateLayout()
    {
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
}
