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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
    }
    
    func prepareUI() {
        
        let footView = UIView()
        tableView.tableFooterView = footView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
