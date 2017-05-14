//
//  PostViewController.swift
//  Kulture
//
//  Created by bis on 5/13/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var footerViewYConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide(_:)),
            name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow(_:)),
            name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) { 
            self.footerViewYConstraint.constant = 0
        }
    }

    func keyboardWillShow(_ notification: Notification) {
        let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        UIView.animate(withDuration: 0.2) {
            self.footerViewYConstraint.constant = frame.height
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
}
