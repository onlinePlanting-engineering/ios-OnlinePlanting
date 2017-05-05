//
//  UpdateProfileTableViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 5/5/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit


protocol UpdateProfileTableViewControllerDelegate: NSObjectProtocol {
    func saveUpdatedInformation(_ type: UserProfile?, information: AnyObject?)
}

class UpdateProfileTableViewController: UITableViewController {
    
    weak var delegate: UpdateProfileTableViewControllerDelegate?
    var type: UserProfile?
    var defaultValue: AnyObject?
    var pageTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        setNavigarationBar()
    }
    
    func setNavigarationBar() {
        
        let rightDoneItem = UIBarButtonItem.createBarButtonItemWithText("Done", CGRect(x: 0, y: 0, width: 40, height: 30), self, #selector(dismissCurrentView), UIColor.white, 16)
        navigationItem.rightBarButtonItem = rightDoneItem
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.title = title
        
        navigationController?.navigationBar.barTintColor = UIColor.init(hexString: OPGreenColor)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 16)!, NSForegroundColorAttributeName: UIColor.white]
    }
    
    func dismissCurrentView() {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func prepareUI() {
        
        let footView = UIView()
        tableView.tableFooterView = footView
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let _ = LocationUtils.sharedInstance.getCurrentLocation()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateProfileTableViewCell", for: indexPath) as!UpdateProfileTableViewCell
        cell.updateTextField.text = defaultValue as? String
        cell.updateTextField.becomeFirstResponder()
        return cell
    }
}
