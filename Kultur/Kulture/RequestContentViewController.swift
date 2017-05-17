//
//  RequestContentViewController.swift
//  Kulture
//
//  Created by Bhalla, Kapil on 5/7/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit


enum UIPickerUser : Int {
    case NONE = 0
    case KID_NAME = 1
    case CATEGORY_NAME = 2
    case REQUEST_TO = 3
}


class RequestContentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var dataPickerView: UIPickerView!
    
    var pickerData: [String] = [String]()
    @IBOutlet weak var uiPickerTitleLabel: UILabel!
    @IBOutlet weak var uiPickerContainerView: UIView!
    
    var currentUIPickerUser: UIPickerUser = UIPickerUser.NONE
    var currentUIPickerValue: String = ""
    @IBOutlet weak var kidNameLabel: UILabel!
    
   
    @IBAction func onKidNameContainerTap(_ sender: Any) {
        // Input data into the Array:
        currentUIPickerUser = UIPickerUser.KID_NAME
        
        setPickerDataAndShow (pickerFor: UIPickerUser.KID_NAME,
                              title: "which kid will see this content",
                              content: ["Riya", "Pete", "Alex", "Samantha"]  )
        
        dataPickerView.reloadAllComponents()
        showUIPickerContainer()
    }
    
    func handleUIPickerSelection (aValue: String) {
        // if Kid is using 
        if (currentUIPickerUser == UIPickerUser.KID_NAME){
            kidNameLabel.text = currentUIPickerValue
        } else if (currentUIPickerUser == UIPickerUser.CATEGORY_NAME) {
            
        } else if (currentUIPickerUser == UIPickerUser.REQUEST_TO) {
            
        }
        
    }
    
    func clearPickerForReuse () {
        uiPickerTitleLabel.text = ""
        pickerData = [""]
        dataPickerView.reloadAllComponents()
    }
    
    func setPickerDataAndShow (pickerFor: UIPickerUser ,title: String, content: [String]) {
        
        currentUIPickerUser = pickerFor
        uiPickerTitleLabel.text = title
        pickerData = content
        
        dataPickerView.reloadAllComponents()
        showUIPickerContainer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // register as UIPickerView datasource and delegate
        self.dataPickerView.delegate = self
        self.dataPickerView.dataSource = self
        hideUIPickerContainer()
                // Do any additional setup after loading the view.
        print ("Request View COntroller Loaded ")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @available(iOS 2.0, *)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        currentUIPickerValue = pickerData[row]
        print ("user selected \(currentUIPickerValue)")
    }
    
    @IBAction func onUIPickerDoneButton(_ sender: Any) {
        // save the value in the selected field
        handleUIPickerSelection(aValue: currentUIPickerValue)
        hideUIPickerContainer()
    }
    
    func hideUIPickerContainer () {
        // animate
        uiPickerContainerView.isHidden = true
    }
    
    func showUIPickerContainer () {
        // animate
        uiPickerContainerView.isHidden = false
    }
    
    @IBAction func goButtonTap(_ sender: Any) {
        // Validate data and save to DB
        // create a content request
        
    }
}
