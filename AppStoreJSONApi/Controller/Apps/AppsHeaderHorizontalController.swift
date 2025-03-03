//
//  appsHeaderHorizontalController.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 19/02/25.
//

import UIKit

class AppsHeaderHorizontalController: HorizontalSnappingController , UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var socialApps = [SocialApp]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor.systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 48, height: view.frame.height)
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return .init(top: 0, left: 16, bottom: 0, right: 16)
//    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return socialApps.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppsHeaderCell
        cell.companyLabel.text = socialApps[indexPath.item].name
        cell.titleLabel.text = socialApps[indexPath.item].tagline
        cell.companyLabel.textColor = .systemBlue
        cell.imageView.sd_setImage(with: URL(string: socialApps[indexPath.item].imageUrl))
        return cell
    }
    
}
