//
//  PostSet.swift
//  mobile_IG4
//
//  Created by user165108 on 25/02/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import Foundation
import Combine
class CommentsSet : ObservableObject,Decodable,Encodable{
    
    @Published var data: Array<Comment>
    var post_id : Int
    
    
    func encode(to encoder : Encoder) throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data,forKey: .data)
    }
    
    enum CodingKeys: CodingKey{
        case post_id
        case data
    }
    
    required init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.post_id = try container.decode(Int.self,forKey: .post_id)
        self.data = try container.decode(Array<Comment>.self,forKey: .data)
       
        
    }
    init(post_id : Int){
        
        self.post_id = post_id
        self.data = Array()
        let jsonData = getJSON(post_id: post_id)
     
        for comment in jsonData {
            
            self.data.append(comment)
        }
    }

    
    func getJSON(post_id: Int) -> [Comment] {
        var res: [Comment] = []
        let group = DispatchGroup()
        group.enter()
     
        if let url = URL(string: "http://51.255.175.118:2000/post/"+String(post_id)+"/comments") {
            
            URLSession.shared.dataTask(with: url) { data, response, error in
            
                if let data = data {
                  
                    do {
                      
                        res = try JSONDecoder().decode([Comment].self, from: data)
                        
                        group.leave()
                    } catch let error {
                        
                        print(error)
                    }
                }
              
            }.resume()
        }
       
        group.wait()
        return res
    }
}
