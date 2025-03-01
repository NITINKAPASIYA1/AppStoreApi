//
//  AppSearchController.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 15/02/25.
//

import UIKit
import SDWebImage

class AppSearchController: BaseListController , UICollectionViewDelegateFlowLayout , UISearchBarDelegate {
    
    
    fileprivate let cellId = "id123"
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    fileprivate let enterSearchTermLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter search term above..."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    var appResults = [Result]()
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appId = String(appResults[indexPath.item].trackId)
        let appDetailController =  AppDetailController(appId:appId)
        navigationController?.pushViewController(appDetailController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        extendedLayoutIncludesOpaqueBars = false
        collectionView.backgroundColor = .white
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.addSubview(enterSearchTermLabel)
        enterSearchTermLabel.fillSuperview(padding: .init(top: 100, left: 50, bottom: 0, right: 50))
        setupSearchBar()
//        fetchItunesApps()
        
    }
    
    fileprivate func setupSearchBar(){
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    var timer : Timer?
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            //Fire your search here
            Service.shared.fetchApps(serachTerm: searchText) { res, err in
                
                if let err {
                    print("Failed to fetch apps:",err)
                    return
                }
                
                self.appResults = res?.results ?? []
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            
        })
    }
   
   
    
   
    fileprivate func fetchItunesApps(){
        
        Service.shared.fetchApps(serachTerm: "instagram") { (results,err) in
            
            if let err = err {
                print("Failed to fetch apps:",err)
                return
            }
            
            self.appResults = results?.results ?? []
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }

    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 350)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        enterSearchTermLabel.isHidden = appResults.count != 0
        return appResults.count
    }
        
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchResultCell
        cell.appResult = appResults[indexPath.item]
        return cell
        
    }
    
}

