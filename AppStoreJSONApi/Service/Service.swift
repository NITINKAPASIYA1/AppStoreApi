//
//  Service.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 17/02/25.
//

import Foundation

class Service {
    
    static let shared = Service() //Singleton
    
    
    func fetchApps(serachTerm : String,completion : @escaping (SearchResult?,Error?) -> ()){
        
        let urlString = "https://itunes.apple.com/search?term=\(serachTerm)&entity=software"
        fetchGenericJSONData(urlString: urlString, completion: completion)
        
    }
    
    
    func fetchAppFeed(feedType: String = "top-free", completion: @escaping (AppGroup?,Error?) -> ()) {
        guard let url = URL(string: "https://rss.marketingtools.apple.com/api/v2/in/apps/\(feedType)/25/apps.json") else {return}
        
        fetchGenericJSONData(urlString: url.absoluteString, completion: completion) //this will fire you request
    
    }
    
    
    func fetchSocialApps(completion:@escaping ([SocialApp]?,Error?) -> ()) {
        let urlString = "https://api.letsbuildthatapp.com/appstore/social"
        
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    
    //Declare my generic json function here
    func fetchGenericJSONData<T: Decodable>(urlString: String, completion: @escaping (T?, Error?) -> ()) {
        
        URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
            if let error = error {
                print("Failed to fetch social apps:",error)
                completion(nil,error)
                return
            }
            
            //            guard let data = data else {return}
            do{
                let objects = try JSONDecoder().decode(T.self,from: data!)
                //success
                completion(objects,nil)
            }catch{
                print("Failed to decode json:",error)
                completion(nil,error)
            }
            
        }
        .resume()
    }
    
    
    
    func fetchMusic(completion: @escaping ([Result]?, Error?) -> Void) {
        guard let url = URL(string: "https://rss.marketingtools.apple.com/api/v2/in/music/most-played/50/songs.json") else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No data received", code: 0, userInfo: nil))
                return
            }
            
            do {
                let musicResponse = try JSONDecoder().decode(MusicApiResponse.self, from: data)
                
                let results = musicResponse.feed.results.map { $0.toResult() }
                print(results)
                completion(results, nil)
            } catch {
                print("JSON Decoding Error for Music API: \(error)")
                completion(nil, error)
            }
        }.resume()
    }
    
        
}
