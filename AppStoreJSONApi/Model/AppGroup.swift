//
//  AppGroup.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 19/02/25.
//

import Foundation

struct AppGroup: Decodable {
    
    let feed : Feed
}

struct Feed: Decodable {
    
    var title : String
    var results : [FeedResult]
    
}


struct FeedResult: Decodable ,Hashable{
    let id : String
    let name : String
    let artistName : String
    let artworkUrl100 : String
    
}
