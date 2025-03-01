//
//  TodayMultipleAppsController.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 24/02/25.
//

import UIKit

class TodayMultipleAppsController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    var apps = [FeedResult]()
    
    // Add this property to handle the dismiss callback
    var dismissHandler: (() -> ())?
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close_button"), for: .normal)
        button.tintColor = .systemBlue
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    // Update the dismiss method to call the dismissHandler
    @objc fileprivate func handleDismiss(button: UIButton) {
        button.isHidden = true
        dismiss(animated: true) {
            // Call the dismissHandler when dismissal is complete
            self.dismissHandler?()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appController = AppDetailController(appId: apps[indexPath.item].id)
        navigationController?.pushViewController(appController, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mode == .fullScreen {
            setupCloseButton()
            navigationController?.isNavigationBarHidden = true
        }
        else {
            collectionView.isScrollEnabled = false
        }
        
        collectionView.backgroundColor = .white
        
        collectionView.register(MultipleAppCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 12), size: .init(width: 80, height: 44))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if mode == .fullScreen {
            return .init(top: 12, left: 24, bottom: 12, right: 24)
        }
        return .zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if mode == .fullScreen {
            return apps.count
        }
        return min(4, apps.count)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MultipleAppCell
        cell.app = self.apps[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 74
        
        if mode == .fullScreen {
            return .init(width: view.frame.width - 48, height: height)
        }
        
        return .init(width: view.frame.width, height: height)
    }
    
    fileprivate let spacing: CGFloat = 16
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    fileprivate let mode: Mode
    
    enum Mode {
        case small, fullScreen
    }
    
    init(mode: Mode) {
        self.mode = mode
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
