//
//  SearchResult.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 17/02/25.
//

import Foundation


struct SearchResult:Decodable {
    let resultCount : Int
    let results : [Result]
    
}

struct Result:Decodable {
    let trackName : String
    let primaryGenreName : String
    var averageUserRating : Float?
    let screenshotUrls : [String]
    let artworkUrl100 : String //App icon
}
