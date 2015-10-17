//
//  DDSLoadingViewController.swift
//  Concorsi_Gazzetta
//
//  Created by Damiano Di Stefano on 26/09/15.
//  Copyright © 2015 Damiano Di Stefano. All rights reserved.
//

import UIKit
import MRProgress

class DDSLoadingViewController: UIViewController
{
    @IBOutlet weak var circularActivityIndicator: MRActivityIndicatorView!
    @IBOutlet weak var appLogo: UIImageView!
    
    override func viewDidLoad() -> ()
    {
        super.viewDidLoad()
        
        circularActivityIndicator.startAnimating()
        animateAppLogo()
        DDSGazzettaStore.sharedInstance.setLoaderDelegate(viewController: self)
        
    }

    override func didReceiveMemoryWarning() -> ()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Animation View
    
    private func animateAppLogo() -> ()
    {
        let expandTransform:CGAffineTransform = CGAffineTransformMakeScale(1.15, 1.15)
        let images = [UIImage(named: "Cravatta"),UIImage(named: "CravattaBeige"),UIImage(named: "CravattaRossa")]

        UIView.transitionWithView(appLogo, duration:0.1,
                                    options: UIViewAnimationOptions.TransitionCrossDissolve,
                                    animations:
                                    {
                                        var index = Int(images.indexOf({ $0 == self.appLogo.image})!.value)
                                        self.appLogo.image = images[++index % 3]
                                        self.appLogo.transform = expandTransform
                                    },
                                    completion:
                                    {
                                        (finished: Bool) in
                
                                            UIView.animateWithDuration(0.4, delay:0.0, usingSpringWithDamping:0.40, initialSpringVelocity:0.2,
                                                                        options:UIViewAnimationOptions.CurveEaseOut,
                                                                        animations:
                                                                        {
                                                                            self.appLogo.transform = CGAffineTransformInvert(expandTransform)
                                                                        },
                                                                        completion:
                                                                        {   (finished: Bool) in
                                                                                if self.circularActivityIndicator.isAnimating()
                                                                                {
                                                                                    self.animateAppLogo()
                                                                                }
                                                                        })
                                    })
        
    }
    
    //MARK: Gazzette Loader Delegate
    
    func onLoadingComplete()
    {
        self.circularActivityIndicator.stopAnimating()
        

        
        
        dispatch_async(dispatch_get_main_queue(),
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initial = storyboard.instantiateInitialViewController() as! DDSSplitViewController
                initial.delegate = initial
                initial.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                self.presentViewController(initial, animated: true, completion: nil)
            })
        
 
        
    }
    
    // MARK: Status Bar Light
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return .LightContent
    }
    
}
