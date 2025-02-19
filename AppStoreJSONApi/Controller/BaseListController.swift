//
//  BaseListController.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 18/02/25.
//

import Foundation
import UIKit

class BaseListController : UICollectionViewController {
    
    
    init(){
        super.init(collectionViewLayout:UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
