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
        if let url = URL(string: "http://51.255.175.118:2000/opinion/create") {
                    var request = URLRequest(url: url)
          
                    
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.httpMethod = "POST"
                    request.httpBody = encoded
        
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
    
}
