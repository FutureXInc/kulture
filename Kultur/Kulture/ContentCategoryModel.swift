//
//  ContentCategoryModel.swift
//  Kulture
//
//  Created by Bhalla, Kapil on 5/16/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit

class ContentCategoryModel: NSObject {
    
    var categoryName: String
    var categoryDescription: String
    
    init (pCategoryName: String, pCategoryDescription: String){
        self.categoryName = pCategoryName
        self.categoryDescription = pCategoryDescription
    }
}
