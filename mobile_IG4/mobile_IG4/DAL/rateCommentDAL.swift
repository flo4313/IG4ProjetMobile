//
//  rateCommentDAL.swift
//  mobile_IG4
//
//  Created by user165108 on 15/03/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import Foundation
import SwiftUI

class RateCommentDAL{
    
        struct ToEncode : Codable{
           var author:Int
           var comment:Int
            var like:Int
       }
       struct Result: Decodable{
           var result : String
       }
       
    
    func rate(user : User, comment:Comment, like: Int){
        var result = ""
        let curUser = user

        if let user = curUser.user {
         
            let group = DispatchGroup()
            group.enter()
            
            let encod = ToEncode(author: user.user_id, comment: comment.comment_id, like: like)
            guard let encoded = try? JSONEncoder().encode(encod) else {
                print("Failed to encode order")
                return
            }
            if let url = URL(string: "https://thomasfaure.fr/rateComment/create") {
                        var request = URLRequest(url: url)
              
                        
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        request.httpMethod = "PUT"
                        request.httpBody = encoded
                        request.setValue("Bearer "+curUser.token,forHTTPHeaderField: "Authorization")
            
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
            if(result == "rated") {
                comment.objectWillChange.send()
                if(like == 1) {
                    comment.like += 1
                } else {
                    comment.dislike += 1
                }
                
            } else if(result == "deleted") {
                comment.objectWillChange.send()
                if(like == 1) {
                    comment.like -= 1
                } else {
                    comment.dislike -= 1
                }
            } else if (result == "updated"){
                comment.objectWillChange.send()
                if(like == 1) {
                    comment.like += 1
                    comment.dislike -= 1
                } else {
                    comment.like -= 1
                    comment.dislike += 1
                }
            }
        }
    }
    
    struct ResultHasRated : Decodable {
        var author : Int
        var comment: Int
        var like : Int
    }
    
    func hasRated(user : User, comment : Comment) -> Int {
        /*return values:
         - -1 : not rated
         - 0 : disliked
         - 1 : liked
        */
        var result = -1
            if let user = user.user{
            
            
                let group = DispatchGroup()
                group.enter()

                if let url = URL(string: "https://thomasfaure.fr/rateComment/\(user.user_id)/\(comment.comment_id)/") {
                        var request = URLRequest(url: url)
              
                        
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        request.httpMethod = "GET"
            
                        URLSession.shared.dataTask(with: request) { data, response, error in
                           if let data = data {
                                               let res = try? JSONDecoder().decode([ResultHasRated].self, from: data)
                                               if let res2 = res{
                                                    if res2.count != 0 {
                                                        result = res2[0].like
                                                    } else {
                                                        result = -1
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
                return result
        }

        return result
    }
}
