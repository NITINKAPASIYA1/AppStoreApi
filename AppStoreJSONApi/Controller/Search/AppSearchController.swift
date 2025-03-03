//
//  AppSearchController.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 15/02/25.
//

import UIKit
import SDWebImage

class AppSearchController: BaseListController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    fileprivate let cellId = "id123"
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    fileprivate let enterSearchTermLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter search term above..."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    fileprivate let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "No results found"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.isHidden = true
        return label
    }()
    
    var appResults = [Result]()
    var isSearching = false
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appId = String(appResults[indexPath.item].trackId)
        let appDetailController = AppDetailController(appId: appId)
        navigationController?.pushViewController(appDetailController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        extendedLayoutIncludesOpaqueBars = false
        collectionView.backgroundColor = UIColor.systemBackground
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
        
        // Add both labels to the collection view
        collectionView.addSubview(enterSearchTermLabel)
        enterSearchTermLabel.fillSuperview(padding: .init(top: 100, left: 50, bottom: 0, right: 50))
        
        collectionView.addSubview(noResultsLabel)
        noResultsLabel.fillSuperview(padding: .init(top: 100, left: 50, bottom: 0, right: 50))
        
        setupSearchBar()
    }
    
    fileprivate func setupSearchBar() {
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    var timer: Timer?
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Clear "no results" label when typing
        noResultsLabel.isHidden = true
        
        timer?.invalidate()
        
        if searchText.isEmpty {
            // Clear results and show initial message when search text is empty
            appResults = []
            enterSearchTermLabel.isHidden = false
            noResultsLabel.isHidden = true
            isSearching = false
            collectionView.reloadData()
            return
        }
        
        isSearching = true
        
        // App Store-like timer with shorter delay (0.3 seconds instead of 0.5)
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { [weak self] _ in
            guard let self = self else { return }
            
            Service.shared.fetchApps(serachTerm: searchText) { res, err in
//                guard let self = self else { return }
                
                if let err = err {
                    print("Failed to fetch apps:", err)
                    return
                }
                
                self.appResults = res?.results ?? []
                
                DispatchQueue.main.async {
                    self.updateSearchResults()
                }
            }
        })
    }
    
    func updateSearchResults() {
        collectionView.reloadData()
        
        // here we are showing the "No result" and "Enter search result"
        if isSearching && appResults.isEmpty {
            enterSearchTermLabel.isHidden = true
            noResultsLabel.isHidden = false
        } else {
            noResultsLabel.isHidden = true
            enterSearchTermLabel.isHidden = !appResults.isEmpty
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        appResults = []
        isSearching = false
        enterSearchTermLabel.isHidden = false
        noResultsLabel.isHidden = true
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 350)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchResultCell
        cell.appResult = appResults[indexPath.item]
        return cell
    }
}

