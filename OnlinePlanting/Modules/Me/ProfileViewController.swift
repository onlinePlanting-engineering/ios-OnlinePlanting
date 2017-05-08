//
//  ProfileViewController.swift
//  OnlinePlanting
//
//  Created by IBM on 5/3/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//
import UIKit
import SDWebImage
import CoreData

enum UserProfile: Int {
    case portrait
    case gender
    case address
    case nickname
    case none
}

enum Gender: String {
    case M, F, O
}

protocol ProfileViewControllerDelegate: NSObjectProtocol {
    func updateUserImage(_ image: UIImage?)
}

class ProfileViewController: UIViewController {
    
    fileprivate let numberOfRows = 4 //portrait, gender, address, nickname
    fileprivate var uploadAlertController: UIAlertController?
    fileprivate var genderSettingController: UIAlertController?
    fileprivate var imagePickerController: UIImagePickerController?
    
    fileprivate var userProfile: Profile?
    fileprivate var changedType: UserProfile = .none
    weak var delegate: ProfileViewControllerDelegate?
    var imgHeading: UIImageView?
    
    
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
        initChangeGenderAlertController()
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
    }
    
    func dismissLoginView() {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let imageAbsoluteURL = appDelegate.currentUser?.profile?.img_heading ?? ""
        imgHeading?.sd_setImage(with: URL(string: imageAbsoluteURL), placeholderImage: UIImage(named: "logo"))
        userProfile = appDelegate.currentUser?.profile
    }
}

extension ProfileViewController: UITableViewDelegate {
    
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

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OPMeDetailedTableViewCell", for: indexPath) as! OPMeDetailedTableViewCell
        switch indexPath.row {
        case UserProfile.portrait.rawValue:
            cell.title.text = "Avatar"
            cell.profileinfor.text = ""
        case UserProfile.address.rawValue:
            cell.title.text = "Location"
            cell.profileinfor.text = appDelegate.currentUser?.profile?.addr
        case UserProfile.gender.rawValue:
            cell.title.text = "Sex"
            //display sex information
            let gender = appDelegate.currentUser?.profile?.gender ?? "O"
            switch  gender {
            case  Gender.M.rawValue:
                cell.profileinfor.text = "Male"
            case  Gender.F.rawValue:
                cell.profileinfor.text = "Female"
            case  Gender.O.rawValue:
                cell.profileinfor.text = "Others"
            default:
                cell.profileinfor.text = "Others"
            }
            
        case UserProfile.nickname.rawValue:
            cell.title.text = "Nick name"
            cell.profileinfor.text = appDelegate.currentUser?.profile?.nickname
        default:
            break
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let alterView = uploadAlertController, let genderView = genderSettingController else { return }
        switch indexPath.row {
        case UserProfile.portrait.rawValue:
            present(alterView, animated: true, completion: nil)
        case UserProfile.address.rawValue:
            //TODO
            var userAddress = ""
            if let profileAddress = appDelegate.currentUser?.profile?.addr, profileAddress != "" {
                userAddress = profileAddress
            } else if let userCity = appDelegate.currentLocation?.city, let userProvince = appDelegate.currentLocation?.province {
                userAddress = userCity + ", " + userProvince
            } else {
                userAddress = "unknow"
            }
            showUpdateProfileVC(UserProfile.address, defaultValue: userAddress as AnyObject, title: "Address")
        case UserProfile.gender.rawValue:
            present(genderView, animated: true, completion: nil)
        case UserProfile.nickname.rawValue:
            showUpdateProfileVC(UserProfile.nickname, defaultValue: appDelegate.currentUser?.profile?.nickname as AnyObject, title: "Nick name")
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showUpdateProfileVC(_ type: UserProfile, defaultValue: AnyObject, title: String) {
        if let updatedVC = UIStoryboard(name: "OPMe", bundle: nil).instantiateViewController(withIdentifier: "UpdateProfileTableViewController") as? UpdateProfileTableViewController {
            updatedVC.type = type
            updatedVC.defaultValue = defaultValue
            updatedVC.delegate = self
            updatedVC.title = title
            navigationController?.pushViewController(updatedVC, animated: true)
        }
    }
}

// Change Avatar
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:- UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String :Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imgHeading?.image = image
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgHeading?.image = image
        } else{
            print("Something went wrong")
        }
        saveUpdatedInformation(.portrait, information: imgHeading)
        picker.dismiss(animated:true, completion:nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated:true, completion:nil)
    }
    
    func initImagePickerController() {
        imagePickerController = UIImagePickerController()
        imagePickerController?.delegate = self
        imagePickerController?.allowsEditing = true
    }
    
    func actionPhotoAction(_ action: UIAlertAction) {
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
        uploadAlertController?.view.tintColor = UIColor(hexString: OPGreenColor)
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] (action) in
            self?.actionPhotoAction(action)
        })
        
        let photoLib = UIAlertAction(title: "Choose from Library", style: .default, handler: { [weak self] (action) in
            self?.actionPhotoAction(action)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] (action) in
            self?.actionPhotoAction(action)
        })
        
        uploadAlertController?.addAction(takePhoto)
        uploadAlertController?.addAction(photoLib)
        uploadAlertController?.addAction(cancel)
    }
}

extension ProfileViewController {
    
    func actionGenderAction(_ gender: Gender) {
        saveUpdatedInformation(UserProfile.gender, information: gender.rawValue as AnyObject?)
    }
    
    func initChangeGenderAlertController()
    {
        genderSettingController = UIAlertController(title: "Setting your gender", message: nil, preferredStyle:UIAlertControllerStyle.actionSheet)
        genderSettingController?.view.tintColor = UIColor(hexString: OPGreenColor)
        
        let other = UIAlertAction(title: "Other", style: .default, handler: { [weak self] (action) in
            self?.actionGenderAction(.O)
        })
        
        let male = UIAlertAction(title: "Male", style: .default, handler: { [weak self] (action) in
            self?.actionGenderAction(.M)
        })
        
        let female = UIAlertAction(title: "Female", style: .default, handler: { [weak self] (action) in
            self?.actionGenderAction(.F)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            //self?.genderSettingController?.dismiss(animated: true, completion: nil)
        })
        
        genderSettingController?.addAction(other)
        genderSettingController?.addAction(male)
        genderSettingController?.addAction(female)
        genderSettingController?.addAction(cancel)
    }
    
}

extension ProfileViewController: UpdateProfileTableViewControllerDelegate {
    
    func saveUpdatedInformation(_ type: UserProfile?, information: AnyObject?) {
        guard let profileType = type else { return }
        switch profileType {
        case .address:
            if userProfile?.addr == information as? String { return }
            userProfile?.addr = information as? String ?? ""
            changedType = .address
        case .gender:
            if userProfile?.gender == information as? String { return }
            userProfile?.gender = information as? String ?? "O"
            changedType = .gender
        case .nickname:
            if userProfile?.nickname == information as? String { return }
            userProfile?.nickname = information as? String ?? ""
            changedType = .nickname
        case .portrait:
            changedType = .portrait
        default:
            changedType = .none
            break
        }
        
        OPLoadingHUD.show(UIImage(named: "hud_loading"), title: "Saving profile", animated: true, delay: 0.0)
        updateUserProfile(type) { [weak self](success) in
            self?.userProfile = appDelegate.currentUser?.profile
            self?.profileTableView.reloadData()
            //TODO:refresh the cell
            if success {
                if self?.changedType == .portrait {
                    self?.delegate?.updateUserImage(self?.imgHeading?.image)
                }
                OPLoadingHUD.show(UIImage(named: "operate_success"), title: "Saving success", animated: false, delay: 0.5)
            } else {
                OPLoadingHUD.show(UIImage(named: "operate_failed"), title: "Saving failed", animated: false, delay: 0.5)
            }
        }
    }
    
    func updateUserProfile(_ changeType: UserProfile?, handler: @escaping (Bool)-> Void) {
        OPDataService.sharedInstance.updateUserProfile(appDelegate.currentUser?.id, username: appDelegate.currentUser?.username, gender: userProfile?.gender, address: userProfile?.addr, nickname: userProfile?.nickname, portriate: imgHeading?.image ?? UIImage(named: "logo")) { (success, error) in
            if success {
                handler(true)
            } else {
                handler(false)
            }
        }
    }
}
