//
//  HomeContainerViewController.swift
//  Kulture
//
//  Created by Bhalla, Kapil on 5/7/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit

class HomeContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    var originalLeftMargin: CGFloat!
    
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            
            if oldContentViewController != nil {
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            
            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            
            UIView.animate(withDuration: 0.3) { () -> Void in
                self.leftMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }

    
    var menuViewController: MenuViewController! {
        
        didSet {
            // to initialize the view
            view.layoutIfNeeded()
            
            // add to the menu view the view contained in the menuViewController.
            menuView.addSubview(menuViewController.view)
        }
    }
    
    
    @IBAction func slideContentViewPGR(_ sender: UIPanGestureRecognizer) {
//        print ("Sliding the view")
        
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            originalLeftMargin = leftMarginConstraint.constant
        } else if sender.state == .changed {
            leftMarginConstraint.constant = originalLeftMargin + translation.x
        }
        else if sender.state == .ended {
            
            UIView.animate(withDuration: 0.4, animations: {
                if velocity.x > 0 { // open menu view
                    self.leftMarginConstraint.constant = self.view.frame.size.width - 125
                } else { // close menu view
                    self.leftMarginConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
        }
    }

    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!

}
