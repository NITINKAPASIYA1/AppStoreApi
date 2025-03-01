//
//  SocialApp.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 20/02/25.
//

import Foundation

struct SocialApp: Decodable , Hashable{
    let id :String
    let name : String
    let imageUrl : String
    let tagline : String
}

