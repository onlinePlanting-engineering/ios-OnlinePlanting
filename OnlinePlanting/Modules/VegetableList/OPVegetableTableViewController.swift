//
//  OPVegetableTableViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 02/06/2017.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit
import CoreData

class OPVegetableTableViewController: CoreDataTableViewController {
    
    lazy var setup: () = {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SeedVegetablesMeta")
        request.sortDescriptors = [NSSortDescriptor(key: "first_letter", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: appDelegate.dataStack.mainContext, sectionNameKeyPath: "first_letter", cacheName: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.sectionIndexBackgroundColor = UIColor.clear
        tableView.sectionIndexColor = UIColor.init(hexString: OPGreenColor)
        let _ = setup
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OPVegetableMetaTableViewCell", for: indexPath) as! OPVegetableMetaTableViewCell
        guard let vegMeta = fetchedResultsController?.object(at: indexPath) as? SeedVegetablesMeta else { return cell }
        cell.delegate = self
        cell.updateDataSource(vegMeta)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.fetchedResultsController?.sections?[section]
        let metaSection = section?.objects?.first as? SeedVegetablesMeta
        guard let titleName = metaSection?.first_letter else { return nil }
        return titleName
    }
}

extension OPVegetableTableViewController: OPVegetableMetaTableViewCellDelegate {
    
    func updateVegetableImage(_ meta: SeedVegetablesMeta?, handler: @escaping ((Images?, Bool, NSError?) -> ())) {
        
        guard let groups = meta?.imgs?.allObjects as? [ImageURL], groups.count > 0 else { return }
        if let groupId = groups.first?.url?.components(separatedBy: "/")[3], let idInt64 = Int64(groupId) {
            OPDataService.sharedInstance.getImageGroup(idInt64) { (success, error) in
                if success {
                    if let imageGroup = OPDataService.sharedInstance.fetchImageGroupById(idInt64), imageGroup.count > 0 {
                        handler(imageGroup.first?.imgs?.allObjects.first as? Images, true, nil)
                    } else {
                        handler(nil, false, error)
                    }
                } else {
                    handler(nil, false, error)
                }
            }
        }
    }
}

extension OPVegetableTableViewController {
    
    //hide or show the tabbar while scrolling up and down
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            showHideTabBar(hidden: true, animated: true)
        }
        else {
            showHideTabBar(hidden: false, animated: true)
        }
    }
    
    func showHideTabBar(hidden hide: Bool, animated: Bool) {
        var originY: CGFloat = 0
        let height = tableView.frame.height
        if hide {
            originY = height + 49
        } else {
            originY = height - 4
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.tabBarController?.tabBar.frame.origin.y = originY
        }, completion: nil)
    }
}
