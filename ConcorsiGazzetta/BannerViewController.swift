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
        if ADBannerView.instancesRespondToSelector("initWithAdType")
        {
            bannerView = ADBannerView(adType: .Banner)
        }
        else
        {
            bannerView = ADBannerView()
        }
        
        bannerView!.delegate = self
        self.view.addSubview(bannerView!)
        contentController = self.childViewControllers[0]
        print(contentController)
    }
    
    override func viewDidLayoutSubviews()
    {
        var contentFrame = self.view.bounds
        var bannerFrame = CGRectZero;
            
        
        
        // Ask the banner for a size that fits into the layout area we are using.
        // At this point in this method contentFrame=self.view.bounds, so we'll use that size for the layout.
        bannerFrame.size = self.bannerView!.sizeThatFits(contentFrame.size)
            
        if self.bannerView!.bannerLoaded
        {
            contentFrame.size.height -= bannerFrame.size.height
            bannerFrame.origin.y = contentFrame.size.height
        }
        else
        {
            bannerFrame.origin.y = contentFrame.size.height
        }
        self.contentController!.view.frame = contentFrame
        self.bannerView!.frame = bannerFrame
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation
    {
        return contentController!.preferredInterfaceOrientationForPresentation()
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!)
    {
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!)
    {
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool
    {
        
    NSNotificationCenter.defaultCenter().postNotificationName("BannerViewActionWillBegin", object: self)
        return true
    }
    
    func bannerViewActionDidFinish(banner: ADBannerView!)
    {
        NSNotificationCenter.defaultCenter().postNotificationName("BannerViewActionDidFinish", object: self)
    }
    
}
