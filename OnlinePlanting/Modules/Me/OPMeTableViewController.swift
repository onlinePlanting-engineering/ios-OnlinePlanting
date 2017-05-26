//
//  OPMeTableViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 5/3/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit
import SDWebImage

protocol SubScrollDelegate: NSObjectProtocol {
    func customScrollViewDidScroll(_ scrollView: UIScrollView)
    func hideOrShowBottomViewBeginScroll(_ scrollView: UIScrollView)
    func previousPage(_ offset: CGFloat)
}

class OPMeTableViewController: UITableViewController {
    
    weak var delegate: SubScrollDelegate?
    @IBOutlet var meTableView: UITableView!
    @IBOutlet weak var portraitView: UIImageView!
    
    var updatedView: UIImage? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.portraitView.image = self?.updatedView
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "OPMeTableViewCell", bundle: nil)
        meTableView.register(cellNib, forCellReuseIdentifier: "OPMeTableViewCell")
        meTableView.dataSource = self
        meTableView.delegate = self
        
        prepareUI()
    }
    
    func prepareUI() {
        portraitView.layer.cornerRadius = portraitView.bounds.height / 2
        portraitView.layer.masksToBounds = true
        guard let imageURL = appDelegate.currentUser?.profile?.img_heading else { return }
        portraitView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "logo"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.customScrollViewDidScroll(scrollView)
    }
    
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegate?.hideOrShowBottomViewBeginScroll(scrollView)
    }
}

// MARK: - Table view data source
extension OPMeTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        } else {
            return 10
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 20
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 64
        } else {
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OPMeTableViewCell", for: indexPath) as! OPMeTableViewCell
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let profileVc = UIStoryboard.init(name: "OPMe", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
            profileVc.delegate = self
            profileVc.imgHeading = portraitView
            navigationController?.pushViewController(profileVc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension OPMeTableViewController: ProfileViewControllerDelegate {
    
    func updateUserImage(_ image: UIImage?) {
        updatedView = image
    }
}
