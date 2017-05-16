//
//  TimeLineViewController.swift
//  Kulture
//
//  Created by Bhalla, Kapil on 5/7/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit
import Parse

class TimeLineViewController: UIViewController {

    
    private var timeLineViewModel: TimeLineViewModel?
    
    var displayingContentFor: User? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let sampleContentCategory = ContentCategoryModel(pCategoryName: "excercise", pCategoryDescription: "This is a way to keep body and mind healthy.")
        
        API.sharedInstance.saveContentCategory(aContentCategoryObject: sampleContentCategory,
                                               successFunc: { (successResult: ContentCategoryModel) in
            print ("added successfully \(successResult.categoryName) category ")
                                                
        }) { (Error) in
        }
        
        
        API.sharedInstance.fetchContentCategory(successFunc: { (categories) in
            print (categories?.count)
        }, errorFunc: { (Error) in
        })
        
        
        // Do any additional setup after loading the view.
        print ("TimeLine View COntroller Loaded for \(String(describing: displayingContentFor?.emailID)) who is a \(String(describing: displayingContentFor?.role))")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    
//    init (timeLineViewModel: TimeLineViewModel){
//        self.timeLineViewModel = timeLineViewModel
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
