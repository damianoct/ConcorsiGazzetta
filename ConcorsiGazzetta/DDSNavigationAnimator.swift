//
//  NavigationAnimator.swift
//  ConcorsiGazzetta
//
//  Created by Damiano Di Stefano on 11/10/15.
//  Copyright © 2015 Damiano Di Stefano. All rights reserved.
//

import UIKit

/**
    
    Queste animazione per pop e push si possono usare se si sceglie di settare uno sfondo blur al navigation controller (usare il metodo blurNavigationController() ) e mantenerlo costante, quindi bisogna settare lo sfondo delle tableview trasparente per apprezzare l'animazione.

**/

class PushNavigationAnimator: NSObject, UIViewControllerAnimatedTransitioning
{
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    {
        return 0.35
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        let fromViewControllerOriginalFrame = fromViewController!.view.frame // rect that describes the view
        let toViewControllerWidth = toViewController!.view.frame.size.width // the width of rect
        
        transitionContext.containerView()?.addSubview(toViewController!.view)
        toViewController?.view.frame = CGRectOffset(fromViewControllerOriginalFrame, +toViewControllerWidth, 0) // sporta la frame del nuovo controller verso destra rispetto al vecchio controllo di un valore pari alla larghezza / 4
        
        //sposto più velocemente il vecchio controller verso sinistra ed applico il fade fino ad alpha zero
        UIView.animateWithDuration(0.3,
            animations: {
                fromViewController!.view.frame = CGRectOffset(fromViewControllerOriginalFrame, -((toViewControllerWidth) / 4.0), 0)
                fromViewController?.view.alpha = 0
        })
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations:
            {
                toViewController!.view.frame = fromViewControllerOriginalFrame
            },
            completion:
            { (finished: Bool) in
                fromViewController!.view.alpha = 1
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                fromViewController!.view.frame = fromViewControllerOriginalFrame

        })
    }
    
}

class PopNavigationAnimator: NSObject, UIViewControllerAnimatedTransitioning
{
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    {
        return 0.35
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        let fromViewControllerOriginalFrame = fromViewController!.view.frame // rect that describes the view
        let toViewControllerWidth = toViewController!.view.frame.size.width // the width of rect
        
        transitionContext.containerView()?.addSubview(toViewController!.view)
        
        toViewController?.view.alpha = 0 // nascondo il nuovo view controller
        toViewController?.view.frame = CGRectOffset(fromViewControllerOriginalFrame, -(toViewControllerWidth / 4.0), 0) // sposta la frame del nuovo controller verso sinistra rispetto al vecchio controllo di un valore pari alla larghezza / 4
        
        
        
        
        
        
        
        
        //sposto più velocemente il vecchio controller verso destra e applico il fade
        UIView.animateWithDuration(0.28,
            animations: {
                fromViewController!.view.frame = CGRectOffset(fromViewControllerOriginalFrame, +((toViewControllerWidth)), 0)
                //fromViewController?.view.alpha = 0
        })
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations:
            {
                toViewController!.view.frame = fromViewControllerOriginalFrame
                toViewController?.view.alpha = 1
            },
            completion:
            { (finished: Bool) in
                fromViewController!.view.alpha = 1
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                fromViewController!.view.frame = fromViewControllerOriginalFrame
                
        })
    }
    
}