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
            print ("User \(emailText!) is logged in")
        } else {
            // proceed with demo user
            print ("proceeding with demo user \(aUser?.emailID)")
        }
        
        // KapiL Check the role of the user by fetching from user role API end point
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
