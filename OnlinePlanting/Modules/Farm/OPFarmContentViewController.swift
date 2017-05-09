//
//  OPFarmContentViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 5/9/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit

class OPFarmContentViewController: UIViewController {
    
    
    @IBOutlet weak var farmContentTableview: UITableView!
    @IBOutlet weak var farmContentHeaderView: UIView!
    var farm: Farm?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension OPFarmContentViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

extension OPFarmContentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = farmContentTableview.dequeueReusableCell(withIdentifier: "OPFarmContentTableViewCell", for: indexPath as IndexPath) as! OPFarmContentTableViewCell
        cell.updateDataSource(farm)
        return cell
    }

}
