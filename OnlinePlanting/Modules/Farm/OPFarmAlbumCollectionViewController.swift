//
//  OPFarmAlbumCollectionViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 5/20/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import UIKit
import CoreData
import INSPhotoGallery

class OPFarmAlbumCollectionViewController: CoreDataCollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var currentFarm: Farm?
    var imageGroupId = [Int64]()
    
    lazy var setup: () = {
        guard let groups = self.currentFarm?.imgs?.allObjects as? [ImageURL] else { return }
        for groupUrl in groups {
            if let groupId = groupUrl.url?.components(separatedBy: "/")[3], let idInt64 = Int64(groupId) {
                self.imageGroupId.append(idInt64)
            }
        }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Images")
        request.sortDescriptors = [NSSortDescriptor(key: "group", ascending: false), NSSortDescriptor(key: "updated_date", ascending: true)]
        request.predicate = NSPredicate(format:"group IN %@", self.imageGroupId)
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: appDelegate.dataStack.mainContext, sectionNameKeyPath: "group", cacheName: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = setup
        collectionView?.register( UINib.init(nibName: "AlbumHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "albumHeader")
        
        setNavigarationBar()
        
        updataImageSource()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavigarationBar() {
        guard let backImage = UIImage(named: "back_white") else { return }
        let leftArrowItem = UIBarButtonItem.createBarButtonItemWithImage(backImage, CGRect(x: 0, y: 0, width: 28, height: 30), self, #selector(dismissCurrentView))
        navigationItem.leftBarButtonItem = leftArrowItem
    }
    
    func updataImageSource() {
        for groupId in imageGroupId {
            OPDataService.sharedInstance.getImageGroup(groupId) { (success, error) in
                if success {
                    print("load image group success")
                } else {
                    print("load image group failed")
                }
            }
        }
    }
    
    func dismissCurrentView(){
        let _ = navigationController?.popViewController(animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OPFarmAlbumCollectionViewCell", for: indexPath) as! OPFarmAlbumCollectionViewCell
        guard let farmImage = fetchedResultsController?.object(at: indexPath) as? Images else { return cell }
        cell.updateDataSource(farmImage)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! OPFarmAlbumCollectionViewCell
        guard let currentPhoto = fetchedResultsController?.object(at: indexPath) as? Images, let photoGroup = fetchedResultsController?.fetchedObjects as? [Images] else { return }
        
        for photoView in photoGroup {
            if let imageUrl = photoView.img  {
                photoView.imageURL = URL.init(string: Networking.shareInstance.baseURL! + imageUrl)
                photoView.thumbnailImage = UIImage.init(named: "toast_image")
            }
        }
        
        let galleryPreview = INSPhotosViewController(photos: photoGroup, initialPhoto: currentPhoto, referenceView: cell)
        galleryPreview.referenceViewForPhotoWhenDismissingHandler = { photo in
            if let index = photoGroup.index(where: {$0 === photo}) {
                let indexPath = IndexPath(item: index, section: 0)
                let cell = collectionView.cellForItem(at: indexPath) as? OPFarmAlbumCollectionViewCell
                return cell
            }
            return nil
        }
        present(galleryPreview, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 2 - 24, height: 106)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 5, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let section = self.fetchedResultsController?.sections?[section]
        let image = section?.objects?.first as? Images
        let groups = OPDataService.sharedInstance.fetchImageGroupById(image?.group)
        guard let description = groups?.first?.desc else { return CGSize.zero }
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width - 25, height: 1000))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont(name: "Helvetica", size: 16.0)
        label.text = description
        label.sizeToFit()
        let height: CGFloat = label.frame.height > 20 ? label.frame.height + 40 : 44
        return CGSize.init(width: UIScreen.main.bounds.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var headView = AlbumHeaderCollectionReusableView()
        if kind == UICollectionElementKindSectionHeader {
            headView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "albumHeader", for: indexPath) as! AlbumHeaderCollectionReusableView
            let section = self.fetchedResultsController?.sections?[indexPath.section]
            let image = section?.objects?.first as? Images
            let groups = OPDataService.sharedInstance.fetchImageGroupById(image?.group)
            guard let description = groups?.first?.desc, let date = groups?.first?.timestamp else { return headView }
            let cformatter = DateFormatter()
            cformatter.dateFormat = "yyyy-MM-dd"
            let sDate = cformatter.date(from: date)
            cformatter.dateFormat = "yyyy MM dd"
            cformatter.dateStyle = .medium
            headView.headername.text = "\(description)"
            //+ "\(cformatter.string(from: sDate!))"
        }
        return headView
    }
    
}
