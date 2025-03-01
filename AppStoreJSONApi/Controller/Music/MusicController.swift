//
//  MusicController.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 26/02/25.
//

import UIKit

class MusicController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let footId = "footId"
    
    var musicResult = [Result]()
    var currentPage = 0
    let pageSize = 10
    var isLoading = false
    var hasReachedEnd = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(TrackCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(LoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footId)
        
        fetchMusic()
    }
    
    fileprivate func fetchMusic() {
        guard !isLoading && !hasReachedEnd else { return }
        isLoading = true
        collectionView.reloadSections(IndexSet(integer: 0))
        
        Service.shared.fetchMusic { (results, err) in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = err {
                    print("Failed to fetch music:", error)
                    return
                }
                
                let newResults = results ?? []
                
                if self.currentPage == 0 {
                    self.musicResult = Array(newResults.prefix(self.pageSize))
                } else {
                    let startIndex = self.currentPage * self.pageSize
                    let endIndex = min(startIndex + self.pageSize, newResults.count)
                    
                    // here we checking if we have reached the end of the data
                    if startIndex >= newResults.count {
                        self.hasReachedEnd = true
                        self.collectionView.reloadData()
                        return
                    }
                    
                    self.musicResult.append(contentsOf: newResults[startIndex..<endIndex])
                    
                    // If we got fewer items than requested, we've reached the end
                    if endIndex - startIndex < self.pageSize {
                        self.hasReachedEnd = true
                    }
                }
                
                self.collectionView.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == musicResult.count - 1 && !isLoading {
            currentPage += 1
            fetchMusic()
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicResult.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TrackCell
        let music = musicResult[indexPath.item]
        cell.nameLabel.text = music.primaryGenreName
        cell.subTitleLabel.text = music.trackName
        cell.imageView.sd_setImage(with: URL(string: music.artworkUrl100))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footId, for: indexPath) as! LoadingFooter
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return isLoading && !hasReachedEnd ? CGSize(width: collectionView.frame.width, height: 50) : .zero
    }
}
