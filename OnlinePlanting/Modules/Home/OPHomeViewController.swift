//
//  OPHomeViewController.swift
//  OnlinePlanting
//
//  Created by Alex on 4/27/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

protocol OPHomeViewControllerCardSwitchDelegate: NSObjectProtocol {
    func CardSwitchDidSelectedAt(_ index: Int)
}

class OPHomeViewController: UIViewController {
    
    var urlSet = ["https://cdn.pixabay.com/photo/2017/06/20/10/43/pine-cone-2422580_1280.jpg","https://cdn.pixabay.com/photo/2017/06/20/11/23/chili-2422661_1280.jpg","https://cdn.pixabay.com/photo/2017/06/20/04/28/small-town-2421726_1280.jpg"]
    
    fileprivate var dragStartX: CGFloat = 0
    fileprivate var dragEndX: CGFloat = 0
    fileprivate var selectedIndex = 0
    fileprivate let dummyCount = 3
    fileprivate var timer : Timer?
    
    weak var delegate: OPHomeViewControllerCardSwitchDelegate?

    @IBOutlet weak var headCollectionView: UICollectionView!
    @IBOutlet weak var headerlayout: UICollectionViewFlowLayout!
    @IBOutlet weak var pageController: UIPageControl!

    lazy var rightUserItem: UIBarButtonItem = {
        let userImage = UIImage(named: "profile")
        let rightUserItem = UIBarButtonItem.createBarButtonItemWithImage(userImage!, CGRect(x: 0, y: 0, width: 30, height: 30), self, #selector(showProfile))
        return rightUserItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigarationBar()
        prepareUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareUI() {
        headCollectionView.showsVerticalScrollIndicator = false
        headCollectionView.showsHorizontalScrollIndicator = false
        headCollectionView.delegate = self
        headCollectionView.dataSource = self
        headCollectionView.isPagingEnabled = true
        headerlayout.itemSize = CGSize.init(width: UIScreen.main.bounds.width, height: headCollectionView.bounds.height)
        headerlayout.minimumLineSpacing = 0
        headCollectionView.scrollToItem(at: IndexPath.init(row: urlSet.count * 2, section: 0), at: .centeredHorizontally, animated: true)
        starTimer()
    }
    
    func setNavigarationBar() {
        navigationController?.navigationBar.topItem?.title = nil
        navigationController?.navigationBar.topItem?.rightBarButtonItem = rightUserItem
    }
    

    func showProfile() {
        let profileVC = UIStoryboard.init(name: "OPMe", bundle: nil).instantiateInitialViewController() as? OPMeViewController
        navigationController?.pushViewController(profileVC!, animated: true)
    }
}

extension OPHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urlSet.count * dummyCount
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScrollHeaderCell", for: indexPath) as! ScrollHeaderCell
        cell.updateDataSource(urlSet[indexPath.row %  urlSet.count ])
        return cell
    }
    
}

extension OPHomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if headCollectionView.contentOffset.x == 0 {
            headCollectionView.contentOffset.x = CGFloat(2 * urlSet.count) * UIScreen.main.bounds.width
            
        }
        if headCollectionView.contentOffset.x == CGFloat(3 * urlSet.count - 1) * UIScreen.main.bounds.width {
            headCollectionView.contentOffset.x = CGFloat(urlSet.count - 1) * UIScreen.main.bounds.width
        }
        
        let currentPage = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width) % urlSet.count
        pageController.currentPage = currentPage
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width) % urlSet.count
        pageController.currentPage = currentPage
    }
    
    func starTimer () {
        let timer = Timer.init(timeInterval: 4, target: self, selector: #selector(OPHomeViewController.nextPage), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        self.timer = timer
        
    }
    
    func nextPage() {
        if headCollectionView.contentOffset.x == CGFloat(3 * urlSet.count - 1) * UIScreen.main.bounds.width {
            headCollectionView.contentOffset.x = CGFloat(urlSet.count - 1) * CGFloat(urlSet.count - 1) * UIScreen.main.bounds.width
        } else {
            headCollectionView.contentOffset.x += UIScreen.main.bounds.width
        }
        
        let currentPage = Int(headCollectionView.contentOffset.x / UIScreen.main.bounds.width) % urlSet.count
        pageController.currentPage = currentPage
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        starTimer()
    }
}
