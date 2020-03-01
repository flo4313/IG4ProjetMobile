//
//  UserModel.swift
//  mobile_IG4
//
//  Created by Thomas Faure on 01/03/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import Foundation
struct UserModel: Decodable{
    var user_id:Int
     var firstname:String
     var lastname:String
     var username:String
     var mail:String
     var sexe:String
     var birthday:String
     var admin:Int
}
