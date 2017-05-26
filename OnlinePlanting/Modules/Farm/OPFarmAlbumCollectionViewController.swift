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
    
    lazy var setup: () = {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FarmImage")
        request.sortDescriptors = [NSSortDescriptor(key: "updated_date", ascending: false), NSSortDescriptor(key: "img", ascending: true)]
        if let parent = self.currentFarm {
            let parentId = parent.id
            request.predicate = NSPredicate(format: "owner.id == %lld", parentId)
        }
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: appDelegate.dataStack.mainContext, sectionNameKeyPath: "updated_date", cacheName: nil)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = setup
        collectionView?.register( UINib.init(nibName: "AlbumHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "albumHeader")
        
        setNavigarationBar()
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
    
    func dismissCurrentView(){
        let _ = navigationController?.popViewController(animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OPFarmAlbumCollectionViewCell", for: indexPath) as! OPFarmAlbumCollectionViewCell
        guard let farmImage = fetchedResultsController?.object(at: indexPath) as? FarmImage else { return cell }
        cell.updateDataSource(farmImage)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! OPFarmAlbumCollectionViewCell
        guard let currentPhoto = fetchedResultsController?.object(at: indexPath) as? FarmImage, let photoGroup = fetchedResultsController?.fetchedObjects as? [FarmImage] else { return }
        
        for photoView in photoGroup {
            photoView.imageURL = URL.init(string: photoView.img!)
            photoView.thumbnailImage = UIImage.init(named: "toast_image")
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
        return CGSize.init(width: UIScreen.main.bounds.width, height: 44)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var headView = AlbumHeaderCollectionReusableView()
        if kind == UICollectionElementKindSectionHeader {
            headView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "albumHeader", for: indexPath) as! AlbumHeaderCollectionReusableView
            let section = self.fetchedResultsController?.sections?[indexPath.section]
            let title = section?.objects?.first as? FarmImage
            guard let titlename = title?.updated_date else { return headView }
            let cformatter = DateFormatter()
            cformatter.dateFormat = "yyyy-MM-dd"
            let sDate = cformatter.date(from: titlename)
            cformatter.dateFormat = "yyyy MM dd"
            cformatter.dateStyle = .medium
            headView.headername.text = "\(cformatter.string(from: sDate!))"
        }
        return headView
    }
    
}
