//
//  AppCompositionalView.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 27/02/25.
//

import SwiftUI
import UIKit


class CompositionalController : UICollectionViewController {
    
    class CompositionalHeader : UICollectionReusableView {
        
        let label: UILabel = {
            let lbl = UILabel()
            lbl.font = .boldSystemFont(ofSize: 32)
            lbl.textColor = .label  // Adjust text color dynamically
            return lbl
        }()
        
        let label2: UILabel = {
            let lbl = UILabel()
            lbl.font = .boldSystemFont(ofSize: 32)
            lbl.textColor = .label  // Adjust text color dynamically
            return lbl
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(label)
            addSubview(label2)
            label.fillSuperview(padding: .init(top: 0, left: 0, bottom: 0, right: 0))
            label2.fillSuperview(padding: .init(top: 0, left: 0, bottom: 0, right: 0))
            label2.isHidden = true
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
    }
    
    let headId = "headerId"
    
    init() {
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection in
            
            if sectionNumber == 0 {
                return CompositionalController.topSection()
            }
            else {
                //second section
                
                let item = NSCollectionLayoutItem.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)))
                item.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 16)
                
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(300)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group:group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets.leading = 16
                
                let kind = UICollectionView.elementKindSectionHeader
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: kind, alignment: .topLeading)
                ]
                return section
            }
        }
        super.init(collectionViewLayout: layout)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        navigationItem.title = "Apps"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .label
        
        collectionView.register(CompositionalHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headId)
        collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: "smallCellId")
        
        navigationItem.rightBarButtonItem = .init(title: "Fetch Paid", style: .plain, target: self, action: #selector(handleFetchTopPaid))
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        //        fetchApps()
        setupDiffableDatasource()
    }
    
    @objc func handleRefresh() {
        
        collectionView.refreshControl?.endRefreshing()
        
        var snapshot = diffableDataSource.snapshot()
        
        snapshot.deleteSections([.topPaid])
        
        diffableDataSource.apply(snapshot)
    }
    
    @objc func handleFetchTopPaid() {
        Service.shared.fetchAppFeed(feedType: "top-paid") { [weak self] appGroup, _ in
            guard let self = self, let paidApps = appGroup?.feed.results else { return }
            
            // Get current snapshot
            var snapshot = self.diffableDataSource.snapshot()
            
            // Save existing data
            let socialApps = snapshot.itemIdentifiers(inSection: .topSocial)
            let freeApps = snapshot.itemIdentifiers(inSection: .topFree)
            
            // Delete all sections to reorder them
            snapshot.deleteSections(snapshot.sectionIdentifiers)
            
            // Reappend sections with social first, then paid, then free
            snapshot.appendSections([.topSocial, .topPaid, .topFree])
            
            // Add back the items
            snapshot.appendItems(socialApps, toSection: .topSocial)
            snapshot.appendItems(paidApps, toSection: .topPaid)
            snapshot.appendItems(freeApps, toSection: .topFree)
            
            // Apply the new snapshot
            self.diffableDataSource.apply(snapshot, animatingDifferences: true)
            
            }
    }
    
    
    enum AppSection {
        case topSocial , topPaid , topFree
    }
    
    
    lazy var diffableDataSource: UICollectionViewDiffableDataSource<AppSection, AnyHashable> = .init(collectionView: self.collectionView) { (collectionView, indexPath, object) -> UICollectionViewCell? in
            
            if let object = object as? SocialApp {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! AppsHeaderCell
                cell.app = object
                return cell
            }
            else if let object = object as? FeedResult {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallCellId", for: indexPath) as! AppRowCell
                cell.app = object
                cell.getButton.addTarget(self, action: #selector(self.handleGet), for: .primaryActionTriggered)
                return cell
            }
            return nil
        }
    
    @objc func handleGet(button:UIView) {
        
        var superview  = button.superview
        
        //i am want react the parent cell of the get button
        while superview != nil {
            if let cell = superview as? UICollectionViewCell {
                
                    guard let indexPath = collectionView.indexPath(for: cell) else {return}
                    guard let objectClickOnto = diffableDataSource.itemIdentifier(for: indexPath) else {return}
                    
                    var snapshot = diffableDataSource.snapshot()
                    snapshot.deleteItems([objectClickOnto])
                    diffableDataSource.apply(snapshot)
                
                }
                superview = superview?.superview
            }
    }
    
    fileprivate func setupDiffableDatasource() {
        
        // Setup header provider with section titles
        diffableDataSource.supplementaryViewProvider = .some({ [weak self] collectionView, elementKind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: elementKind,
                withReuseIdentifier: self?.headId ?? "",
                for: indexPath) as! CompositionalHeader
            
            let sectionTitles: [AppSection: String] = [
                .topSocial: "Top Social Apps",
                .topFree: "Top Free Apps",
                .topPaid: "Top Paid Apps"
            ]
            
            if let section = self?.diffableDataSource.snapshot().sectionIdentifiers[indexPath.section] {
                header.label.text = sectionTitles[section] ?? ""
            }
            
            return header
        })
        
        // Create dispatch group to handle multiple async requests
        let dispatchGroup = DispatchGroup()
        
        var socialApps: [SocialApp]?
        var topFreeApps: [FeedResult]?
        var topPaidApps: [FeedResult]?
        
        // Fetch social apps
        dispatchGroup.enter()
        Service.shared.fetchSocialApps { apps, _ in
            socialApps = apps
            dispatchGroup.leave()
        }
        
        // Fetch top free apps
        dispatchGroup.enter()
        Service.shared.fetchAppFeed(feedType: "top-free") { appGroup, _ in
            topFreeApps = appGroup?.feed.results
            dispatchGroup.leave()
        }
        
        // Fetch top paid apps
        dispatchGroup.enter()
        Service.shared.fetchAppFeed(feedType: "top-paid") { appGroup, _ in
            topPaidApps = appGroup?.feed.results
            dispatchGroup.leave()
        }
        
        // When all fetches complete, update the UI
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self, let socialApps = socialApps else { return }
            
            var snapshot = NSDiffableDataSourceSnapshot<AppSection, AnyHashable>()
            
            // Add sections and items
            snapshot.appendSections([.topSocial, .topFree, .topPaid])
            snapshot.appendItems(socialApps.map { AnyHashable($0) }, toSection: .topSocial)
            
            if let topFreeApps = topFreeApps {
                snapshot.appendItems(topFreeApps, toSection: .topFree)
            }
            
            if let topPaidApps = topPaidApps {
                snapshot.appendItems(topPaidApps, toSection: .topPaid)
            }
            
            self.diffableDataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headId, for: indexPath) as! CompositionalHeader
        
        // Configure the correct label based on section
        if indexPath.section == 1 {
            header.label.isHidden = false
            header.label2.isHidden = true
        } else if indexPath.section == 2 {
            header.label.isHidden = true
            header.label2.isHidden = false
        }
        
        return header
    }
    
    static func topSection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets.bottom = 16
        item.contentInsets.trailing = 16
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(300)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = 16
        return section
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let object = diffableDataSource.itemIdentifier(for: indexPath)
        if let object  = object as? SocialApp {
            let appDetailController = AppDetailController(appId: object.id)
            navigationController?.pushViewController(appDetailController, animated: true)
        }
        else {
            let appDetailController = AppDetailController(appId: (object as! FeedResult).id)
            navigationController?.pushViewController(appDetailController, animated: true)
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

struct AppView : UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = CompositionalController()
        return UINavigationController(rootViewController: controller)
    }
    
}



#Preview {
    AppView()
        .ignoresSafeArea(.all)
}

    
//    var socialApps = [SocialApp]()
//    var appGroup : AppGroup?
//    var appGroup2 : AppGroup?
//    
//    private func fetchApps() {
//        Service.shared.fetchSocialApps(completion: { (res,err) in
//            DispatchQueue.main.async {
//                self.socialApps = res ?? []
//                
//                Service.shared.fetchAppFeed(feedType: "top-free") { (res,err) in
//                    DispatchQueue.main.async {
//                        self.appGroup = res ?? nil
//                        
//                        Service.shared.fetchAppFeed(feedType: "top-paid") { (res,err) in
//                            DispatchQueue.main.async {
//                                self.appGroup2 = res ?? nil
//                                self.collectionView.reloadData()
//                            }
//                        }
//                        self.collectionView.reloadData()
//                    }
//                }
//                self.collectionView.reloadData()
//            }
//        })
//    }
//    
   

//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 0 {
//            return socialApps.count
//        }
//        else if section == 1 {
//            return appGroup?.feed.results.count ?? 0
//        }
//        return appGroup2?.feed.results.count ?? 0
//    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.section == 0 {
//            navigationController?.pushViewController(AppDetailController(appId: socialApps[indexPath.item].id), animated: true)
//        }
//        else if indexPath.section == 1{
//            navigationController?.pushViewController(AppDetailController(appId: appGroup?.feed.results[indexPath.item].id ?? ""), animated: true)
//        }
//        else {
//            navigationController?.pushViewController(AppDetailController(appId: appGroup2?.feed.results[indexPath.item].id ?? ""), animated: true)
//        }
//    }
    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        switch indexPath.section {
//            case 0:
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! AppsHeaderCell
//                cell.companyLabel.text = socialApps[indexPath.item].name
//                cell.titleLabel.text = socialApps[indexPath.item].tagline
//                cell.companyLabel.textColor = .systemBlue
//                cell.imageView.sd_setImage(with: URL(string: socialApps[indexPath.item].imageUrl))
//                return cell
//                
//            case 1:
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallCellId", for: indexPath) as! AppRowCell
//                let app = appGroup?.feed.results[indexPath.item]
//                cell.nameLabel.text = app?.name
//                cell.companyLabel.text = app?.artistName
//                cell.imageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
//                return cell
//                
//            case 2:
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallCellId", for: indexPath) as! AppRowCell
//                let app = appGroup2?.feed.results[indexPath.item]
//                cell.nameLabel.text = app?.name
//                cell.companyLabel.text = app?.artistName
//                cell.imageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
//                return cell
//                
//            default:
//                return UICollectionViewCell()
//                
//        }
//        
//    }
    
    


