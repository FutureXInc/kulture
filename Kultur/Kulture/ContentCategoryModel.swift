//
//  ContentCategoryModel.swift
//  Kulture
//
//  Created by Bhalla, Kapil on 5/16/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit
import Parse

class ContentCategoryModel: NSObject {
    
    var objectId: String?
    var categoryName: String
    var categoryDescription: String
    
    init (pID: String?, pCategoryName: String, pCategoryDescription: String){
        self.objectId = pID
        self.categoryName = pCategoryName
        self.categoryDescription = pCategoryDescription
    }
    
    static func getContentCategory(aPFObject: PFObject) -> ContentCategoryModel {
        let returnObject = ContentCategoryModel(pID: aPFObject[ContentCategoryAPI._ID] as? String, pCategoryName: aPFObject[ContentCategoryAPI.COLUMN_CATEGORY_NAME] as! String,
                                                pCategoryDescription: aPFObject[ContentCategoryAPI.COLUMN_CATEGORY_DESCRIPTION] as! String)
        
        return returnObject
    }
}
