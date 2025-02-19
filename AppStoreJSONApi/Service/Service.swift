//
//  Service.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 17/02/25.
//

import Foundation

class Service {
    
    static let shared = Service() //Singleton
    
    
    func fetchApps(serachTerm : String,completion : @escaping ([Result],Error?) -> ()){
        
        let urlString = "https://itunes.apple.com/search?term=\(serachTerm)&entity=software"
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch apps:",error)
                completion([],nil)
                return
            }
            
            guard let data = data else {return}
            print(data)
            
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                completion(searchResult.results,nil)
            } catch let jsonError {
                print("Failed to decode json:",jsonError)
                completion([],jsonError)
            }
            
           
            
            if let response = response as? HTTPURLResponse {
                print("Status Code: ",response.statusCode)
            }
            
            
        }.resume()
    }
}
