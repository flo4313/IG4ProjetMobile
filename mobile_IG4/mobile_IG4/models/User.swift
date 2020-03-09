//
//  User.swift
//  mobile_IG4
//
//  Created by user165108 on 28/02/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import Foundation

class User : ObservableObject,Identifiable, Codable {
    
    @Published var isLogged: Bool = false
    @Published var user: UserModel? = nil
    @Published var token: String = ""
    
    var user_id: Int = 0
    var username : String = "test"
    var firstname : String = ""
    var lastname : String = ""
    var mail : String = ""
    var password : String = ""
    var birthday : Date = Date()
    var sexe : String
    
    func encode(to encoder : Encoder) throws{
        encoder.container(keyedBy: CodingKeys.self)
    }
    
    enum CodingKeys: CodingKey{
        case user_id
        case username
        case firstname
        case lastname
        case mail
        case password
        case birthday
        case sexe
    }
    
    required init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.user_id = try container.decode(Int.self,forKey: .user_id)
        self.username = try  container.decode(String.self,forKey: .username)
        self.firstname = try  container.decode(String.self,forKey: .firstname)
        self.lastname = try  container.decode(String.self,forKey: .lastname)
        self.mail = try container.decode(String.self,forKey: .mail)
        self.birthday = try  container.decode(Date.self,forKey: .birthday)
        self.sexe = try  container.decode(String.self,forKey: .sexe)
        
    }
    
    init(user_id : Int, username :String ,firstname: String, lastname: String, mail: String, password: String, birthday: Date, sexe :String) {
        self.user_id = user_id
        self.username = username
        self.firstname = firstname
        self.lastname = lastname
        self.mail = mail
        self.password = password
        self.birthday = birthday
        self.sexe = sexe
    }
    
    init(){
        self.sexe = ""
    }


}
