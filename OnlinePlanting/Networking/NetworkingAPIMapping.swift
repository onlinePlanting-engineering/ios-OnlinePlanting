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
    case GetFarmComments = "/api/comments/"
    case CreateComment = "/api/comments/create/"
    
    //Image
    case GetImageByGroup = "/api/image_groups/"
}


