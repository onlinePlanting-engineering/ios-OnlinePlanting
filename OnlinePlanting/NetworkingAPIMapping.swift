//
//  NetworkingAPIMapping.swift
//  OnlinePlanting
//
//  Created by IBM on 4/27/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation

enum WebServiceAPIMapping: String {
    
    //login
    case UserRegistraion               = "/api/users/register/"
    case UserLogin         = "/api/users/login/"
    case GetToken          = "/api/auth/token/"
}

