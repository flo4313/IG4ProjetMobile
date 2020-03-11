//
//  postDAL.swift
//  mobile_IG4
//
//  Created by etud on 10/03/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import Foundation
import SwiftUI

class PostDAL{
    
    struct AddPostForm : Codable{
        var title:String
        var description:String
        var author : Int
    }
    
    struct Response :Decodable {
        var result: Bool
        var id: Int
    }
    
    
    func addPost(title:String, description: String, userId: Int) -> Bool{
        let post = AddPostForm(title: title, description: description, author: userId)
        guard let encoded = try? JSONEncoder().encode(post) else {
            print("Failed to encode order")
            return false
        }
        var isCreate = false
        var id = 0
        let group = DispatchGroup()
        group.enter()
        if let url = URL(string: "http://51.255.175.118:2000/post/create") {
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Application")
            request.httpMethod = "POST"
            request.httpBody = encoded
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    let res = try? JSONDecoder().decode(Response.self, from: data)
                    if let res2 = res{
                        print(res2.result)
                        if(res2.result == true){
                            isCreate = true
                            id=res2.id
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