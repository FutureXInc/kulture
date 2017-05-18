//
//  RequestContentViewController.swift
//  Kulture
//
//  Created by Bhalla, Kapil on 5/7/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit
import Parse
import FTIndicator

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
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var requestToLabel: UILabel!
    @IBOutlet weak var categoryDescriptionLabel: UITextView!
   
    var contentCategories: [ContentCategoryModel] = []
    var familyMembers: [User] = []
    var kids: [User] = []
    var uiPickerDisplayDictionary = [String: AnyObject]()
    var familyMembersDict = [String: User]()
    var kidsDict = [String: User]()
    
    
    @IBAction func onGoButtonTap(_ sender: Any) {
        // save the request on DB
        
        
        FTIndicator.showProgressWithmessage("sending request to \(self.requestToLabel.text!) ...", userInteractionEnable: false)
        
        let kidId: String? = (kidsDict[kidNameLabel.text!])?.userId
        let familyMId: String? = (familyMembersDict[requestToLabel.text!])?.userId
        
        if (kidId != nil && familyMId != nil){
            API.sharedInstance.saveContentRequest(kidUserId: kidId!,
                                              familyMemberId: familyMId!,
                msg: categoryDescriptionLabel.text,
                tag: categoryLabel.text!, errorFunc: nil) {
                    print ("content request submitted successfully")
                    // Show notification
                    FTIndicator.dismissProgress()
                    //self.dismiss(animated: true, completion: nil)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewContentRequestVC = storyboard.instantiateViewController(withIdentifier: "view_content_request")
                        as! ViewContentRequestViewController
                    
//                    var kidName: String? = ""
//                    var parentName: String? = ""
//                    var familyMemberName: String? = ""
//                    var contentRequestMessage: String? = ""
                    
                    viewContentRequestVC.kidName = self.kidNameLabel.text!
                    viewContentRequestVC.parentName = "KapiL"
                    viewContentRequestVC.familyMemberName = self.requestToLabel.text!
                    viewContentRequestVC.contentRequestMessage = self.categoryDescriptionLabel.text!
                    
                    self.present(viewContentRequestVC, animated: true, completion: nil)
                    
//                    homeContainerViewController?.contentViewController = home
//                        viewModel?.getMenuViewItems()[1].clickHandler
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // register as UIPickerView datasource and delegate
        self.dataPickerView.delegate = self
        self.dataPickerView.dataSource = self
        hideUIPickerContainer()
        // Do any additional setup after loading the view.
        print ("Request View COntroller Loaded ")
        fetchRequiredData()
    }

    
    func fetchRequiredData () {
        let sampleContentCategory = ContentCategoryModel(pID: "", pCategoryName: "Greeting", pCategoryDescription: "how to greet people when you meet them.")
        
        API.sharedInstance.saveContentCategory(aContentCategoryObject: sampleContentCategory,
                                               successFunc: { (successResult: ContentCategoryModel) in
                                                print ("added successfully \(successResult.categoryName) category ")
                                                
        }) { (Error) in
        }
        // FEtch content categories
        API.sharedInstance.fetchContentCategory(successFunc: { (categories) in
            if (categories != nil){
                print (categories?.count)
                for aCategory in categories!{
                    let aCategoryObj: ContentCategoryModel = ContentCategoryModel.getContentCategory(aPFObject: aCategory)
                    self.contentCategories.append(aCategoryObj)
                }
            }
        }, errorFunc: { (Error) in
        })
        
        // Get the family members associated with logged in parent
        let familyMemberIds = UserCache.sharedInstance.familyMemberIds
        for aFamilyMemberId in familyMemberIds {
            let familyMember: User? = UserCache.sharedInstance.getUser(aFamilyMemberId)
            
            if (familyMember != nil){
                familyMembers.append(familyMember!)
            }
        }
        
        let kidIDs = UserCache.sharedInstance.kidIds
        for aKidId in kidIDs {
            let aKid: User? = UserCache.sharedInstance.getUser(aKidId)
            if (aKid != nil){
                kids.append(aKid!)
            }
        }
    }
    
    
    @IBAction func onKidNameContainerTap(_ sender: Any) {
        clearPickerForReuse()
        // Set the Kid name container
        setPickerDataAndShow (pickerFor: UIPickerUser.KID_NAME,
                              title: "which kid will see this content")
    }
    
    @IBAction func onCategoryContainerTap(_ sender: Any) {
        clearPickerForReuse()
        // Set the Category name container
        setPickerDataAndShow (pickerFor: UIPickerUser.CATEGORY_NAME,
                              title: "Learning category for \((kidNameLabel.text!))")
    }
    
    
    @IBAction func onRequestContainerTap(_ sender: Any) {
        clearPickerForReuse()
        // Set the Request to container
        setPickerDataAndShow (pickerFor: UIPickerUser.REQUEST_TO,
                              title: "Who might help \((kidNameLabel.text!)) learn about \((categoryLabel.text!))?")
    }
    
    
    func handleUIPickerSelection (aValue: String) {
        // if Kid is using 
        if (currentUIPickerUser == UIPickerUser.KID_NAME){
            kidNameLabel.text = currentUIPickerValue
        } else if (currentUIPickerUser == UIPickerUser.CATEGORY_NAME) {
            categoryLabel.text = currentUIPickerValue
            // fetch the content category description
            categoryDescriptionLabel.text = (self.uiPickerDisplayDictionary[currentUIPickerValue] as? ContentCategoryModel)?.categoryDescription
        } else if (currentUIPickerUser == UIPickerUser.REQUEST_TO) {
            requestToLabel.text = currentUIPickerValue
        }
        clearPickerForReuse()
    }
    
    func clearPickerForReuse () {
        uiPickerTitleLabel.text = ""
        pickerData = [""]
        self.uiPickerDisplayDictionary.removeAll()
        dataPickerView.selectedRow(inComponent: 0)
        dataPickerView.reloadAllComponents()
    }
    
    func setPickerDataAndShow (pickerFor: UIPickerUser ,title: String) {
        
        // set the display dictionary
        if (pickerFor == UIPickerUser.KID_NAME){
            for aKidObj in kids {
                self.uiPickerDisplayDictionary[aKidObj.userName] = aKidObj
                self.kidsDict[aKidObj.userName] = aKidObj
            }
        } else if (pickerFor == UIPickerUser.CATEGORY_NAME) {
            for aCategoryObj in contentCategories {
                self.uiPickerDisplayDictionary[aCategoryObj.categoryName]=aCategoryObj
                
            }
        } else if (pickerFor == UIPickerUser.REQUEST_TO) {
            for aFamilyMember in familyMembers {
                self.uiPickerDisplayDictionary[aFamilyMember.userName] = aFamilyMember
                self.familyMembersDict[aFamilyMember.userName] = aFamilyMember
            }
        }

        currentUIPickerUser = pickerFor
        uiPickerTitleLabel.text = title
        pickerData = Array(self.uiPickerDisplayDictionary.keys)
        
        dataPickerView.reloadAllComponents()
        showUIPickerContainer()
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
        if (row<pickerData.count && row>=0){
            currentUIPickerValue = pickerData[row]
        }
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
