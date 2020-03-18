//
//  opinionDAL.swift
//  mobile_IG4
//
//  Created by etud on 10/03/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import Foundation
import SwiftUI

class OpinionDAL{
    
    struct ToEncode : Codable{
           var author:Int
           var post:Int
       }
       struct Result: Decodable{
           var result : String
       }
       
    
    func like(user : User, post:Post){
        var result = ""
        
        var user_id = 0
        if let tmp = user.user?.user_id {
            user_id = tmp
        }
        
        let group = DispatchGroup()
        group.enter()
        
        let encod = ToEncode(author: user_id, post: post.post_id)
        guard let encoded = try? JSONEncoder().encode(encod) else {
            print("Failed to encode order")
            return
        }
        if let url = URL(string: "https://thomasfaure.fr/opinion/create") {
                    var request = URLRequest(url: url)
          
                    
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.httpMethod = "POST"
                    request.httpBody = encoded
                    request.setValue("Bearer "+user.token,forHTTPHeaderField: "Authorization")
        
                    URLSession.shared.dataTask(with: request) { data, response, error in
                       if let data = data {
                                           let res = try? JSONDecoder().decode(Result.self, from: data)
                                           if let res2 = res{
                                                result = res2.result
                                           }else{
                                               print("error")
                                           }
                                    group.leave()
                       
                                   }
                    }.resume()
        } else {
            print("Failed to acces URL")
        }
        group.wait()
        if(result == "liked") {
            post.objectWillChange.send()
            post.like += 1
        } else if(result == "deleted") {
            post.objectWillChange.send()
            post.like -= 1
        }
    }
        
    struct ResultHasLiked : Decodable {
        var author : Int
        var post: Int
        var like : Int
    }
    
    func hasLiked(user : User, post : Post) -> Bool {
        var result = 0
            if let user_id = user.user?.user_id {
            
            
            let group = DispatchGroup()
            group.enter()

                if let url = URL(string: "https://thomasfaure.fr/opinion/\(user_id)/\(post.post_id)/") {
                        var request = URLRequest(url: url)
              
                        
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        request.httpMethod = "GET"
            
                        URLSession.shared.dataTask(with: request) { data, response, error in
                           if let data = data {
                                               let res = try? JSONDecoder().decode([ResultHasLiked].self, from: data)
                                               if let res2 = res{
                                                if res2.count != 0 {
                                                    result = res2[0].like
                                                }
                                               }else{
                                                   print("error")
                                               }
                                        group.leave()
                                       }
                        }.resume()
            } else {
                print("Failed to acces URL")
            }
            group.wait()
                if(result == 1) {
                return true
            } else {
                return false
            }

        }
        return false
    }
    
}

