//
//  ProfileViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 5/3/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//
import UIKit

enum UserProfile: Int {
    case portrait
    case gender
    case address
    case nickname
}

class ProfileViewController: UIViewController {
    
    fileprivate let numberOfRows = 4 //portrait, gender, address, nickname
    fileprivate var uploadAlertController: UIAlertController?
    fileprivate var imagePickerController: UIImagePickerController?
    fileprivate var imgHeading: UIImageView?
    fileprivate var gender: Int?
    fileprivate var address: String?
    fileprivate var nickname: String?
    
    lazy var profileTableView: UITableView = {
        let profileTableView = UITableView()
        profileTableView.backgroundColor = UIColor.clear
        //remove the extra tableview line
        let footView = UIView()
        profileTableView.tableFooterView = footView
        
        self.view.addSubview(profileTableView)
        profileTableView.translatesAutoresizingMaskIntoConstraints = false
        profileTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        profileTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive  = true
        profileTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive  = true
        profileTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive  = true
        return profileTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        setNavigarationBar()
        initChangePortraitAlertController()
        initImagePickerController()
    }
    
    func setNavigarationBar() {
        guard let backImage = UIImage(named: "back_white") else { return }
        let leftArrowItem = UIBarButtonItem.createBarButtonItemWithImage(backImage, CGRect(x: 0, y: 0, width: 28, height: 30), self, #selector(dismissLoginView))
        navigationItem.leftBarButtonItem = leftArrowItem
        
        navigationController?.navigationBar.barTintColor = UIColor.init(hexString: OPGreenColor)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 16)!, NSForegroundColorAttributeName: UIColor.white]
        navigationItem.title = "Edit Profile"
        
    }
    
    func prepareUI() {
        let _ = profileTableView
        let nib = UINib.init(nibName: "OPMeDetailedTableViewCell", bundle: nil)
        profileTableView.register(nib, forCellReuseIdentifier: "OPMeDetailedTableViewCell")
        profileTableView.dataSource = self
        profileTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func dismissLoginView() {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerview = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 24))
        headerview.backgroundColor = .clear
        return headerview
    }
    
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OPMeDetailedTableViewCell", for: indexPath) as! OPMeDetailedTableViewCell
        switch indexPath.row {
        case UserProfile.portrait.rawValue:
            cell.title.text = "Avatar"
        case UserProfile.address.rawValue:
            cell.title.text = "Nick name"
        case UserProfile.gender.rawValue:
            cell.title.text = "Sex"
        case UserProfile.nickname.rawValue:
            cell.title.text = "Region"
        default:
            break
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let alterView = uploadAlertController else { return }
        switch indexPath.row {
        case UserProfile.portrait.rawValue:
            present(alterView, animated: true, completion: nil)
        case UserProfile.address.rawValue:
            //TODO
//            showUpdateProfileVC(UserProfile.address, defaultValue: appDelegate.currentUser?.profile?.addr as AnyObject)
            showUpdateProfileVC(UserProfile.address, defaultValue: "Ning Bo, Zhe Jiang" as AnyObject)
        case UserProfile.gender.rawValue:
            break
        case UserProfile.nickname.rawValue:
            showUpdateProfileVC(UserProfile.nickname, defaultValue: appDelegate.currentUser?.profile?.nickname as AnyObject)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showUpdateProfileVC(_ type: UserProfile, defaultValue: AnyObject) {
        if let updatedVC = UIStoryboard(name: "OPMe", bundle: nil).instantiateViewController(withIdentifier: "UpdateProfileTableViewController") as? UpdateProfileTableViewController {
            updatedVC.type = type
            updatedVC.defaultValue = defaultValue
            updatedVC.delegate = self
            navigationController?.pushViewController(updatedVC, animated: true)
        }
    }
}

// Change Avatar
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:- UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String :Any]) {
        
        let type: String = (info[UIImagePickerControllerMediaType] as! String)
        
        if type == "public.image" {
            let chooseImg = info[UIImagePickerControllerOriginalImage] as? UIImage
            imgHeading?.image = chooseImg
            picker.dismiss(animated:true, completion:nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated:true, completion:nil)
    }
    
    func initImagePickerController() {
        imagePickerController = UIImagePickerController()
        imagePickerController?.delegate = self
        imagePickerController?.allowsEditing = true
    }
    
    func actionAction(_ action: UIAlertAction) {
        if action.title == "Take Photo" {
            getImageFromPhotoLib(type: .camera)
        } else if action.title == "Choose from Library" || action.title == "Change Portrait" {
            getImageFromPhotoLib(type: .photoLibrary)
        } else if action.title == "Delete Image" {
            //self.headImg.image =UIImage(named:"head")
        }
    }
    
    func getImageFromPhotoLib(type: UIImagePickerControllerSourceType) {
        imagePickerController?.sourceType = type
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            guard let imagePick = imagePickerController else { return }
            present(imagePick, animated: true, completion:nil)
        }
    }
    
    func initChangePortraitAlertController()
    {
        uploadAlertController = UIAlertController(title: "Change profile picture", message: nil, preferredStyle:UIAlertControllerStyle.actionSheet)
        //uploadAlertController?.view.tintColor = UIColor.lightGray
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] (action) in
            self?.actionAction(action)
        })
        
        let photoLib = UIAlertAction(title: "Choose from Library", style: .default, handler: { [weak self] (action) in
            self?.actionAction(action)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] (action) in
            self?.actionAction(action)
        })
        
        uploadAlertController?.addAction(takePhoto)
        uploadAlertController?.addAction(photoLib)
        uploadAlertController?.addAction(cancel)
    }
}

extension ProfileViewController: UpdateProfileTableViewControllerDelegate {
    func saveUpdatedInformation(_ type: UserProfile?, information: AnyObject?) {
        guard let profileType = type else { return }
        switch profileType.rawValue {
        case UserProfile.address.rawValue:
            address = information as? String
        case UserProfile.nickname.rawValue:
            nickname = information as? String
        default: break
        }
    }
}
