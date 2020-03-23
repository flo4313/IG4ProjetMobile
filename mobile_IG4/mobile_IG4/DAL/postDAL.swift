//
//  postDAL.swift
//  mobile_IG4
//
//  Created by etud on 10/03/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation
class PostDAL{
    var config : Config = Config()
    struct AddPostForm : Codable{
        var title:String
        var description:String
        var category : Int
        var `extension` : String
        var data : String
        var location : String
        var anonymous : Bool
    }
    struct AdressResponse : Decodable {
        var village: String?
        var city: String?
    }
    struct LocalisationResponse : Decodable{
        var address : AdressResponse
    }
    
    struct Response :Decodable {
        var result: Bool
        var id: Int
    }
    
    
    func addPost(title:String, description: String, category: Int, image: UIImage?, userE: User, ext: String,latitude: Double?,longitude: Double?,anonymous: Bool) -> Bool{
            var location = ""
            let groupLocation = DispatchGroup()
            groupLocation.enter()
            if let url = URL(string:"https://nominatim.openstreetmap.org/reverse?format=json&lat=\(latitude ?? 0.0)&lon=\(longitude ?? 0.0)&zoom=18&addressdetails=1") {
                var request = URLRequest(url: url)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json", forHTTPHeaderField: "Application")
                request.httpMethod = "GET"
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let data = data {
                        let res = try? JSONDecoder().decode(LocalisationResponse.self, from: data)
                        if let res2 = res{
                         
                            if let city : String = res2.address.city{
                                print(city)
                                location = city
                            }
                            if let village : String = res2.address.village{
                                print(village)
                                location = village
                            }
                            groupLocation.leave()
                            
                        }else{
                          
                            groupLocation.leave()
                        }
                    
                        
                    }
                }.resume()
            }
            
        groupLocation.wait()
     
        var data : String = ""
        if let postImage : UIImage = image{
            data = config.convertImageToBase64(postImage)
        }
        let post = AddPostForm(title: title, description: description, category: category,extension: ext,data: data,location : location,anonymous:anonymous)
        guard let encoded = try? JSONEncoder().encode(post) else {
            print("Failed to encode order")
            return false
        }
        var isCreate = false
        var id = 0
        let group = DispatchGroup()
        group.enter()
        if let url = URL(string: "https://thomasfaure.fr/post/create") {
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Application")
            request.setValue("Bearer "+userE.token,forHTTPHeaderField: "Authorization")
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
    
    struct resultBestAnswer : Decodable {
        var comment_id: Int
        var post : Int
        var description : String
        var rate : Int
    }
    
    func getBestAnswers() -> [resultBestAnswer] {
        var result : [resultBestAnswer] = []
            let group = DispatchGroup()
            group.enter()

                if let url = URL(string: "https://thomasfaure.fr/post/bestAnswer/") {
                        var request = URLRequest(url: url)
              
                        
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        request.httpMethod = "GET"
            
                        URLSession.shared.dataTask(with: request) { data, response, error in
                           if let data = data {
                                               let res = try? JSONDecoder().decode([resultBestAnswer].self, from: data)
                                               if let res2 = res{
                                                    print("success")
                                                    result = res2
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
}
