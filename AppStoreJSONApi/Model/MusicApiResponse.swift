//
//  MusicModel.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 26/02/25.
//

import Foundation

// Separate model structure for Music API
struct MusicApiResponse: Decodable {
    let feed: MusicFeed
}

struct MusicFeed: Decodable {
    let results: [MusicItem]
}

struct MusicItem: Decodable {
    let artistName: String
    let id: String
    let name: String
    let artworkUrl100: String
}


// Extension to map MusicItem to your existing Result structure
extension MusicItem {
    func toResult() -> Result {
        return Result(
            trackName: artistName,
            primaryGenreName:name,
            averageUserRating: nil,
            screenshotUrls: [],
            artworkUrl100: artworkUrl100,
            formattedPrice: nil,
            description: "No description available",
            releaseNotes: nil,
            trackId: Int(id) ?? 0
        )
    }
}
