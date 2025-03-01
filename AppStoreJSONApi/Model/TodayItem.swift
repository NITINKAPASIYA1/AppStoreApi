//
//  TodayItem.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 23/02/25.
//

import UIKit

struct TodayItem {
    
    let category: String
    let title: String
    let image: UIImage
    let description: String
    let backgroundColor: UIColor
    
    let cellType: CellType
    
    let apps : [FeedResult]
    //enum
    enum CellType : String {
        case single,multiple
    }
}
