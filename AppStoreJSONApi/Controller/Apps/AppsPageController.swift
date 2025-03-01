//
//  AppsController.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 18/02/25.
//


import UIKit

class AppsPageController : BaseListController ,UICollectionViewDelegateFlowLayout {
    
    let cellId = "id"
    let headerId = "headerId"
    
    let activityIndicatorView : UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    var editorChoiceApp : AppGroup?
    var group = [AppGroup]()
    var socialApps = [SocialApp]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        extendedLayoutIncludesOpaqueBars = false
        
        collectionView.register(AppsGroupCell.self,forCellWithReuseIdentifier: cellId)
        //No : 1
        collectionView.register(AppsPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
        collectionView.showsVerticalScrollIndicator = false
        
        fetchData()
        
    }
    
    
    fileprivate func fetchData() {
        // Create a dispatch group to wait for multiple requests
        let dispatchGroup = DispatchGroup()
        
        // Fetch free apps
        dispatchGroup.enter()
        Service.shared.fetchAppFeed(feedType: "top-free") { (appGroup, error) in
            defer { dispatchGroup.leave() }
            
            if let error = error {
                print("Failed to fetch free apps:", error)
                return
            }
            
            if let data = appGroup {
                self.group.append(data)
            }
        }
        
        // Fetch paid apps
        dispatchGroup.enter()
        Service.shared.fetchAppFeed(feedType: "top-paid") { (appGroup, error) in
            defer { dispatchGroup.leave() }
            
            if let error = error {
                print("Failed to fetch paid apps:", error)
                return
            }
            
            if let data = appGroup {
                self.group.append(data)
//                self.group.append(data)
            }
        }
        
        dispatchGroup.enter()
        Service.shared.fetchSocialApps { (app,err) in
            defer { dispatchGroup.leave() }
            if let error = err {
                print("Failed to fetch social apps:", error)
                return
            }
            guard let app = app else {return}
            self.socialApps = app
        }
        
        
        
        
        // When all fetches complete, update UI
        dispatchGroup.notify(queue: .main) {
            self.collectionView.reloadData()
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    //No : 2
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AppsPageHeader
        header.appHeaderHorizontalController.socialApps = socialApps
        header.appHeaderHorizontalController.collectionView.reloadData()
        return header
    }
    
    //No : 3
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return group.count
    }
    
    //MARK: App to next page navigation happen here
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppsGroupCell
        
        let appGroup = group[indexPath.item]
        cell.titleLabel.text = appGroup.feed.title
        cell.horizontalController.appGroup = appGroup
        cell.horizontalController.collectionView.reloadData()
        
        cell.horizontalController.didSelectHandler = { [weak self] feedResult in
            
            let controller = AppDetailController(appId: feedResult.id)
            controller.navigationItem.title = feedResult.name
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 12, left: 0, bottom: 0, right: 0)
    }
    
    
}


#Preview{
    AppsPageController()
}
