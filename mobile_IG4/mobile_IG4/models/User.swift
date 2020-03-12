//
//  User.swift
//  mobile_IG4
//
//  Created by user165108 on 28/02/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import Foundation
class User : ObservableObject,Identifiable {
    @Published var isLogged: Bool = false
    @Published var user: UserModel? = nil
    @Published var token: String = ""
}
