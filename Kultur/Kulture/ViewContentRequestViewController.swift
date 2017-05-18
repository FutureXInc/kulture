//
//  ViewContentRequestViewController.swift
//  Kulture
//
//  Created by Bhalla, Kapil on 5/17/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit

class ViewContentRequestViewController: UIViewController {

    var kidName: String? = ""
    var parentName: String? = ""
    var familyMemberName: String? = ""
    var contentRequestMessage: String? = ""
    
    @IBAction func onDoneTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var signatureLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var salutationLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        populateView ()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func populateView(){
        salutationLabel.text = "Dear \(familyMemberName!)"
        
        bodyLabel.text = contentRequestMessage!
        
        signatureLabel.text = parentName!
    }

}
