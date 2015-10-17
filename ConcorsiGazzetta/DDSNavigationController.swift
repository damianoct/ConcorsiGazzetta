//
//  DDSNavigationController.swift
//  iOSConcorsiGazzetta
//
//  Created by Damiano Di Stefano on 11/10/15.
//  Copyright © 2015 Damiano Di Stefano. All rights reserved.
//

import UIKit

class DDSNavigationController: UINavigationController, UINavigationControllerDelegate
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.delegate = self
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        
//        switch operation
//        {
//            case UINavigationControllerOperation.Push: return PushNavigationAnimator()
//            case UINavigationControllerOperation.Pop: return PopNavigationAnimator()
//            default: return nil
//        }
        
        return nil // default animation
    }
    
    private func blurNavigationController() -> ()
    {
        let image = UIImage(named: "newspaper_background_ingiallito.jpg")
        view.backgroundColor = UIColor(patternImage: image!)
        let blur = UIBlurEffect(style: .ExtraLight)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.bounds
        self.view.insertSubview(blurView, atIndex: 0)
    }
    
}
