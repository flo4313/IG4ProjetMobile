//
//  UserDAL.swift
//  mobile_IG4
//
//  Created by etud on 10/03/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import Foundation
import SwiftUI

class UserDAL{
    private var config : Config = Config()
    @Environment(\.presentationMode) var presentationMode
    
   struct Result :Decodable {
       var result: Bool
       
   }
    
    func login(username: String,password: String,userE: User){
        print("test")
        print(userE.isLogged)
        let passwordCrypted = config.sha256(str: password)
        let person = Person(username: username, password: passwordCrypted)
        guard let encoded = try? JSONEncoder().encode(person) else {
            print("Failed to encode order")
            return
        }
        let group = DispatchGroup()
        group.enter()
        
        var user_id = 0
        var token = ""
        var isLogged = false
        if let url = URL(string: "http://51.255.175.118:2000/user/login") {
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Application")
            request.httpMethod = "POST"
            request.httpBody = encoded
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    
                    let res = try? JSONDecoder().decode(Login.self, from: data)
                    if let res2 = res{
                        print(res2.token)
                        token = res2.token
                        user_id = res2.id
                        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                        let urlf = paths[0].appendingPathComponent("login.txt")
                        var str = person.username+"\n"+passwordCrypted
                        try? str.write(to: urlf, atomically: true, encoding: .utf8)
                        isLogged = true
                        
                    }else{
                        print("pas connecté")
                    }
                    group.leave()
                    
                }
            }.resume()
        }
        
        group.wait()
        var user : UserModel? = nil
        if(isLogged){
            group.enter()
            if let url = URL(string: "http://51.255.175.118:2000/user/"+String(user_id)) {
                var request = URLRequest(url: url)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json", forHTTPHeaderField: "Application")
                request.setValue("Bearer "+token,forHTTPHeaderField: "Authorization")
                request.httpMethod = "GET"
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let data = data {
                        print("on a un utilisateur")
                        let res = try? JSONDecoder().decode([UserModel].self, from: data)
                        
                        if let res = res{
                            user = res[0]
                        }
                        group.leave()
                    }
                }.resume()
            }
            group.wait()
            self.presentationMode.wrappedValue.dismiss()
            userE.isLogged = true
            userE.user = user
            userE.token = token
            print(userE.token)
        }
        
    }
    
    struct AddUserForm : Codable{
        var firstname:String
        var username:String
        var lastname:String
        var sexe:String
        var birthday:String
        var password:String
        var mail:String
        
    }
    
    var dataFormatter : DateFormatter{
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    func register(firstname:String, lastname:String, username: String,sexe:Bool,birthday:Date,password:String,mail:String) -> Bool{
        var s : String
        if(sexe){
            s = "M"
        }
        else {
            s = "F"
        }
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let date = df.string(from: birthday)
        let user = AddUserForm(firstname: firstname, username: username, lastname: lastname, sexe: s, birthday: date, password: config.sha256(str: password), mail: mail)
        guard let encoded = try? JSONEncoder().encode(user) else {
            print("Failed to encode order")
            return false
        }
        var isCreate = false
        let group = DispatchGroup()
        group.enter()
        if let url = URL(string: "http://51.255.175.118:2000/user/create") {
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Application")
            request.httpMethod = "POST"
            request.httpBody = encoded
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    let res = try? JSONDecoder().decode(Result.self, from: data)
                    if let res2 = res{
                        if(res2.result == true){
                            isCreate = true
                            print("created")
                        }
                    }else{
                        print("error")
                        
                    }
                    group.leave()
                    
                }
            }.resume()
        }
        group.wait()
        return isCreate
    }    
}
