//
//  TodayController.swift
//  AppStoreJSONApi
//
//  Created by Nitin on 22/02/25.
//

import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    var items = [TodayItem]()
    
    var activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.superview?.setNeedsLayout()
    }
    
    let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        return blurEffectView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(blurEffectView)
        blurEffectView.fillSuperview()
        blurEffectView.alpha = 0
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
        
        navigationController?.isNavigationBarHidden = true
        
        collectionView.backgroundColor = #colorLiteral(red: 0.948936522, green: 0.9490727782, blue: 0.9489068389, alpha: 1)
        
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
        
        fetchData()
    }
    

    fileprivate func fetchData() {
        let dispatchGroup = DispatchGroup()
        
        var topPaidApps : AppGroup?
        var topFreeApps : AppGroup?
        
        dispatchGroup.enter()
        Service.shared.fetchAppFeed(feedType: "top-free") { (appGroup, err) in
            //check
            topFreeApps = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchAppFeed(feedType: "top-paid") { (appGroup, err) in
            topPaidApps = appGroup
            dispatchGroup.leave()
        }
        
        // Completion block
        dispatchGroup.notify(queue: .main, work: DispatchWorkItem { [weak self] in
            print("Finished fetching data")
            self?.activityIndicatorView.stopAnimating()
            
            topPaidApps?.feed.results.forEach({print($0.name)})
            
            self?.items = [
                
                
                
                TodayItem(category: "LIFE HACK",
                          title: "Utilizing your Time",
                          image: #imageLiteral(resourceName: "garden"),
                          description: "All the tools and apps you need to intelligently organize your life the right way.",
                          backgroundColor: .white,
                          cellType: .single, apps: []),
                
                TodayItem(category: "Daily List",
                          title: topPaidApps?.feed.title ?? "",
                          image: #imageLiteral(resourceName: "garden"),
                          description: "",
                          backgroundColor: .white,
                          cellType: .multiple, apps: topPaidApps?.feed.results ?? []),
                
                TodayItem(category: "Daily List",
                          title: topFreeApps?.feed.title ?? "",
                          image: #imageLiteral(resourceName: "garden"),
                          description: "",
                          backgroundColor: .white,
                          cellType: .multiple, apps: topFreeApps?.feed.results ?? []),
                
                TodayItem.init(category: "HOLIDAYS",
                               title: "Travel on a Budget",
                               image: #imageLiteral(resourceName: "holiday"),
                               description: "All the tools and apps you need to intelligently organize your life the right way.",
                               backgroundColor: #colorLiteral(red: 0.9838578105, green: 0.9588007331, blue: 0.7274674177, alpha: 1),
                               cellType: .single,
                               apps: []),
                
                
            ]
            
            self?.collectionView.reloadData()
        })
    }
    
    var appFullscreenController: AppFullscreenController!
    
    var topConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    fileprivate func showDailyListFullscreen(_ indexPath: IndexPath) {
        animateTabBarDown()
        let fullController = TodayMultipleAppsController(mode: .fullScreen)
        fullController.apps = self.items[indexPath.item].apps
        
        // Create the navigation controller
        let navController = BackEnabledNavigationController(rootViewController: fullController)
        
        // Set the modal presentation style on the navigation controller
        navController.modalPresentationStyle = .fullScreen
        
        fullController.dismissHandler = {
            self.animateTabBarUp()
        }
        
        present(navController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch items[indexPath.item].cellType {
            case .multiple:
                showDailyListFullscreen(indexPath)
            default:
                showSingleAppFullscreen(indexPath: indexPath)
        }
        
    }
    
    fileprivate func setupSingleAppFullscreenController(_ indexPath: IndexPath) {
        let appFullscreenController = AppFullscreenController()
        appFullscreenController.todayItem = items[indexPath.row]
        appFullscreenController.dismissHandler = {
            self.handleAppFullscreenDismissal()
        }
        self.appFullscreenController = appFullscreenController
        appFullscreenController.view.layer.cornerRadius = 16
        
        //#1 setup our pan gesture
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
        gesture.delegate = self
        
        appFullscreenController.view.addGestureRecognizer(gesture)
        
        //#2 add a blue effect view
        
        
        //#3 not to interface with our UITableView Scrolling
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    var appFullscreenBeginOffset: CGFloat = 0
    
    @objc fileprivate func handleDrag(gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .began {
            appFullscreenBeginOffset = appFullscreenController.tableView.contentOffset.y
        }
        
        
        if appFullscreenController.tableView.contentOffset.y > 0 {
            return
        }
        
        let translationY = gesture.translation(in: appFullscreenController.view).y
        print(translationY)
        
        
        if gesture.state == .changed {
            
            if translationY > 0 {
                let trueOffset = translationY - appFullscreenBeginOffset
                
                var  scale = 1 - trueOffset / 1000
                
                scale = min(1, scale)
                scale = max(0.5, scale)
                
                let transform : CGAffineTransform = .init(scaleX: scale, y: scale)
                self.appFullscreenController.view.transform = transform
            }
            
        }
        else if gesture.state == .ended {
            if translationY > 0 {
                handleAppFullscreenDismissal()
            }
        }
        
    }

    
    fileprivate func setupStartingCellFrame(_ indexPath : IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        // absolute coordindates of cell
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        
        self.startingFrame = startingFrame
    }
    
    fileprivate func singleAppFullscreenStartingPosition(_ indexPath:IndexPath){
        
        let fullscreenView = appFullscreenController.view!
        view.addSubview(fullscreenView)
        
        addChild(appFullscreenController)
        
        
        self.collectionView.isUserInteractionEnabled = false
        
        setupStartingCellFrame(indexPath)
        
        guard let startingFrame = self.startingFrame else { return }
        
        // auto layout constraint animations
        // 4 anchors
        fullscreenView.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = fullscreenView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
        leadingConstraint = fullscreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin.x)
        widthConstraint = fullscreenView.widthAnchor.constraint(equalToConstant: startingFrame.width)
        heightConstraint = fullscreenView.heightAnchor.constraint(equalToConstant: startingFrame.height)
        
        [topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach({$0?.isActive = true})
        
        
        self.view.layoutIfNeeded()
        
    }
    
    fileprivate func beginAnimationAppFullscreen() {
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.blurEffectView.alpha = 1
            
            self.topConstraint?.constant = 0
            self.leadingConstraint?.constant = 0
            self.widthConstraint?.constant = self.view.frame.width
            self.heightConstraint?.constant = self.view.frame.height
            
            self.view.layoutIfNeeded() // starts animation
            
            // Animate the tab bar down
            self.animateTabBarDown()
            
            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
            
            cell.todayCell.topConstraint.constant = 48
            cell.layoutIfNeeded()
            
        }, completion: nil)
        
    }
    
    fileprivate func showSingleAppFullscreen(indexPath: IndexPath) {
        // #1
        setupSingleAppFullscreenController(indexPath)
        
        // #2 setup fullscreen in its starting position
        singleAppFullscreenStartingPosition(indexPath)
        
        // #3 begin the fullscreen animation
        beginAnimationAppFullscreen()
        
    }
    
    
    
    // Method to animate tab bar down (out of screen)
    fileprivate func animateTabBarDown() {
        self.tabBarController?.tabBar.isHidden = false // Make sure it's visible before animation
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            // Move tab bar offscreen
            self.tabBarController?.tabBar.frame.origin.y = self.view.frame.maxY + 100
            
            // Alternative with transform
             self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
        }, completion: { _ in
            // Hide tab bar after it's moved out
            self.tabBarController?.tabBar.isHidden = true
        })
    }
    
    // Method to animate tab bar up (back into screen)
    fileprivate func animateTabBarUp() {
        self.tabBarController?.tabBar.isHidden = false // Make visible for animation
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            // Reset position
            if let tabBarFrame = self.tabBarController?.tabBar.frame {
                self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height - tabBarFrame.height
            }
            
        })
    }
    
    var startingFrame: CGRect?
    
    @objc func handleAppFullscreenDismissal() {
        self.navigationController?.navigationBar.isHidden = false
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.blurEffectView.alpha = 0
            self.appFullscreenController.view.transform = .identity
            
            self.appFullscreenController.tableView.contentOffset = .zero
            
            guard let startingFrame = self.startingFrame else { return }
            self.topConstraint?.constant = startingFrame.origin.y
            self.leadingConstraint?.constant = startingFrame.origin.x
            self.widthConstraint?.constant = startingFrame.width
            self.heightConstraint?.constant = startingFrame.height
            
            self.view.layoutIfNeeded()
            
            // Animate the tab bar back up
            self.animateTabBarUp()
            
            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
//            cell.closeButton.alpha = 0
            self.appFullscreenController.closeButton.alpha = 0
            cell.todayCell.topConstraint.constant = 24
            cell.layoutIfNeeded()
            
        }, completion: { _ in
            self.appFullscreenController.view.removeFromSuperview()
            self.appFullscreenController.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true
        })
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cellType = items[indexPath.item].cellType.rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType, for: indexPath) as! BaseTodayCell
        cell.todayItem = items[indexPath.item]
        
        (cell as? TodayMultipleAppCell)?.multipleAppController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleAppsTap)))
        
        return cell
        
    }
    
    @objc fileprivate func handleMultipleAppsTap(gesture: UITapGestureRecognizer) {
        
        let collectionView = gesture.view
        
        // figure out which cell we are clicking into
        var superview = collectionView?.superview
        
        while superview != nil {
            if let cell = superview as? TodayMultipleAppCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                
                let apps = self.items[indexPath.item].apps
                
                let fullController = TodayMultipleAppsController(mode: .fullScreen)
                fullController.modalPresentationStyle = .fullScreen
                fullController.apps = apps
                present(fullController, animated: true)
                return
            }
            superview = superview?.superview
        }

    }

    
    static let cellSize: CGFloat = 500
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 40, height: TodayController.cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
}
