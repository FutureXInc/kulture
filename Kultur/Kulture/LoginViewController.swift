//
//  LoginViewController.swift
//  Kulture
//
//  Created by Bhalla, Kapil on 5/7/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit
import Parse


class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func continueButtonAction(_ sender: Any) {
        API.sharedInstance.userLogin(password: passwordTextField.text!,
                                     userName: userNameTextField.text!,
                                     successFunc:
           { (user: PFUser) in
                UserCache.sharedInstance.prePopulateCache(
                    userId: user.objectId!,
                    successFunc: {
                        self.setupHomeContainerBasedOnRole()
                    })
            })
            { (error: Error) in
                print("\(error)")
            }
    }
    
    func setupHomeContainerBasedOnRole () {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuViewController = storyboard.instantiateViewController(withIdentifier: "menu_view_controller") as! MenuViewController
        let menuViewModel: MenuViewModel = MenuViewModel (storyboard: storyboard, forUser: UserCache.currentUser!)
        menuViewModel.getMenuViewItems()
        menuViewController.viewModel = menuViewModel
        launchHomeContainer (aMenuViewController: menuViewController, aMenuViewModel: menuViewModel)
    }
    
    func launchHomeContainer (aMenuViewController: UIViewController, aMenuViewModel: MenuViewModel?)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeContainerViewController = storyboard.instantiateViewController(withIdentifier: "home_container_view_controller") as! HomeContainerViewController
        (aMenuViewController as! MenuViewController).homeContainerViewController = homeContainerViewController
        homeContainerViewController.menuViewController = aMenuViewController as! MenuViewController
        self.show(homeContainerViewController, sender: nil)
    }
}
