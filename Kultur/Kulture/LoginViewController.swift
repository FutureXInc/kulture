//
//  LoginViewController.swift
//  Kulture
//
//  Created by Bhalla, Kapil on 5/7/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initializeDemoUsers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeDemoUsers (){
        // initialize the current user as default parent
        aUser = User.currentUser
    }

    var aUser: User?
    
    @IBOutlet weak var emailTextOutlet: UITextField!
    
    @IBAction func continueButtonAction(_ sender: Any) {
        let emailText: String? = emailTextOutlet.text
        
        if (isEmailValid(email: emailText)){
            aUser?.emailID = emailText!
            if (!setRoleBasedOnEmail ()){
                // check by making a database call the user details for this user.
                
            }
            print ("User \(emailText!) is logged in")
        } else {
            // proceed with demo user
            print ("proceeding with demo user \(aUser?.emailID)")
        }
        
        // KapiL Check the role of the user by fetching from user role API end point
        setupHomeContainerBasedOnRole()
    }
    
    func setRoleBasedOnEmail () -> Bool{
        
        if (aUser?.emailID == "kapil@gmail.com") {
            //Kapil is parent
            aUser?.role = User.UserRole.Parent
        } else if (aUser?.emailID == "biswa@gmail.com") {
            // biswa is family
            aUser?.role = User.UserRole.Family
        } else if (aUser?.emailID == "sada@gmail.com") {
            // sada is kid
            aUser?.role = User.UserRole.Kid
        } else {
            return false
        }
        
        return true
    }
    
    func setupHomeContainerBasedOnRole () {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let menuViewController = storyboard.instantiateViewController(withIdentifier: "menu_view_controller") as! MenuViewController
        let menuViewModel: MenuViewModel = MenuViewModel (storyboard: storyboard, forUser: aUser!)
        menuViewModel.getMenuViewItems()
        menuViewController.viewModel = menuViewModel
        
        if (aUser?.role == User.UserRole.Parent){
            // Parent Menu
            print ("set the Menu View as Parent Memu View Controller")
            
        } else if (aUser?.role == User.UserRole.Family) {
            print ("set the Menu View as Family Memu View Controller")
            
        } else if (aUser?.role == User.UserRole.Kid) {
            print ("set the Menu View as Kid Memu View Controller")
            
        } else {
            // Which role is this. Throw an error or something
            
            print ("Do not know what to set in menu view of the contaienrs")
        }
        
        
        launchHomeContainer (aMenuViewController: menuViewController, aMenuViewModel: menuViewModel)
    }
    
    
    func launchHomeContainer (aMenuViewController: UIViewController, aMenuViewModel: MenuViewModel?){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeContainerViewController = storyboard.instantiateViewController(withIdentifier: "home_container_view_controller") as! HomeContainerViewController
        
        (aMenuViewController as! MenuViewController).homeContainerViewController = homeContainerViewController
        // set the menu view of the home container view controller
        //homeContainerViewController.menuView = aMenuViewController.view
        homeContainerViewController.menuViewController = aMenuViewController as! MenuViewController
        
        
        
        // lunch the home container view controller
        self.show(homeContainerViewController, sender: nil)

    }
    
    func isEmailValid (email anEmail: String?) -> Bool {
        if (anEmail == nil){
            return false
        }
        
        if (!(anEmail?.contains("@"))!){
            return false
        }
        
        return true
    }

}
