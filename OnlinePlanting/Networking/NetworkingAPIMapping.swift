//
//  NetworkingAPIMapping.swift
//  OnlinePlanting
//
//  Created by Alex on 4/27/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation

enum WebServiceAPIMapping: String {
    
    //login
    case UserRegistraion               = "/api/users/register/"
    case UserLogin         = "/api/users/login/"
    case GetToken          = "/api/auth/token/"
    case GetUserProfile    = "/api/users/user_info/"
    case UpdateUserProfile = "/api/users/"
    
    //farm
    case GetFarmList = "/api/farms/"
    case GetComments = "/api/comments/"
    case CreateComment = "/api/comments/create/"
    
    //Image
    case GetImageByGroup = "/api/image_groups/"
    
    //Land & Metas
    case GetLandsById = "/api/land/lands/"
    
    //Vegetables
    case GetSeedCategories = "/api/seed/categories/"
    case GetSeedVegetables = "/api/seed/vegetables/"
    
    //Upload Image
    case UploadImageToServer = "/api/common/images/"
}


