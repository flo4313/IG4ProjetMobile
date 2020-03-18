//
//  ReportPostDAL.swift
//  mobile_IG4
//
//  Created by user165108 on 14/03/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import Foundation
import SwiftUI

class ReportPostDAL {
    struct verifyResponse : Decodable {
        var author : Int
        var post : Int
        var report : Int
    }

    func hasReported(user : User, postElt : Post) -> Bool{
        var result = false
        
        let group = DispatchGroup()
        group.enter()
        
        if let url = URL(string: "https://thomasfaure.fr/reportpost/"+String(postElt.post_id)+"/byToken") {
                    var request = URLRequest(url: url)
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue("application/json", forHTTPHeaderField: "Application")
                    request.httpMethod = "GET"
                    request.setValue("Bearer "+user.token,forHTTPHeaderField: "Authorization")
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        if let data = data {
                                
                            let res = try? JSONDecoder().decode([verifyResponse].self, from: data)
                                if let res = res{
                                    
                                    if(res.count > 0){
                                        result = true
                                    }else{
                                        result = false
                                    }
                                    group.leave()
                                }
                                
                     
                        }
                    }.resume()
            
                }
        group.wait()
        return result
    }

    struct ToEncode : Codable{
        var post_id:Int
    }
    struct Result: Decodable{
        var result : Bool
    }

    func sendReport(user : User, postElt : Post){
       
        let encod = ToEncode(post_id: postElt.post_id)
        guard let encoded = try? JSONEncoder().encode(encod) else {
            print("Failed to encode order")
            return
        }
        if let url = URL(string: "https://thomasfaure.fr/reportpost/create") {
                    var request = URLRequest(url: url)
          
                    
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue("application/json", forHTTPHeaderField: "Application")
                    request.httpMethod = "POST"
                    request.httpBody = encoded
                    request.setValue("Bearer "+user.token,forHTTPHeaderField: "Authorization")
                
        
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        if let data = data {
                                
                            let res = try? JSONDecoder().decode(Result.self, from: data)
                                if let res = res{
                                    if(res.result == true){
                                        print("vraie")
                                    }else{
                                        print("faux")
                                    }
                                }
                                
                     
                        }
                    }.resume()
                }
        
        
    }
}
