//
//  BannerViewManager.swift
//  ConcorsiGazzetta
//
//  Created by Damiano Di Stefano on 18/10/15.
//  Copyright © 2015 Damiano Di Stefano. All rights reserved.
//

import UIKit
import iAd

class BannerViewManager: NSObject, ADBannerViewDelegate
{
    static let shareInstance = BannerViewManager()
    var bannerView: ADBannerView
    private var bannerViewControllers = NSMutableSet()
    
    private override init()
    {
        if ADBannerView.instancesRespondToSelector("initWithAdType")
        {
            bannerView = ADBannerView(adType: .Banner)
        }
        else
        {
            bannerView = ADBannerView()
        }
        super.init()
        bannerView.delegate = self
    }
    
    func addBannerViewController(bannerViewController controller: BannerViewController)
    {
        bannerViewControllers.addObject(controller)
    }
    
    func removeBannerViewController(bannerViewController controller: BannerViewController)
    {
        bannerViewControllers.removeObject(controller)
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!)
    {
        print("\n\t Banner DidLoadAd")
        for controller in bannerViewControllers
        {
            (controller as! BannerViewController).updateLayout()
        }
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!)
    {
        print("\n\t Banner DidFailToReceiveAdWithError\n\t\tError: \(error)")
        for controller in bannerViewControllers
        {
            (controller as! BannerViewController).updateLayout()
        }
    }
}
