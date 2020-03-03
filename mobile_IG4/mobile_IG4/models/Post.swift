//
//  post.swift
//  mobile_IG4
//
//  Created by user165108 on 25/02/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import Foundation
import Combine

class Post : ObservableObject,Identifiable, Codable {
    
    var post_id: Int = 0
    var title : String = "test"
    var description : String = ""
    var post_category : Int = 0
    var author : Int = 0
    var url_image : String = " " 
    var date : String = ""
    @Published var commentsi : CommentsSet?
    
    func encode(to encoder : Encoder) throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(commentsi,forKey: .commentsi)
    }
    
    enum CodingKeys: CodingKey{
        case post_id
        case title
        case description
        case post_category
        case author
        case url_image
        case date
        case commentsi
    }
    func setComments(){
        self.commentsi = CommentsSet(post_id: self.post_id)
       
        
    }
    
    required init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.post_id = try container.decode(Int.self,forKey: .post_id)
        self.title = try  container.decode(String.self,forKey: .title)
        self.description = try  container.decode(String.self,forKey: .description)
        self.post_category = try  container.decode(Int.self,forKey: .post_category)
        self.author = try container.decode(Int.self,forKey: .author)
        self.url_image = try  container.decode(String.self,forKey: .url_image)
        self.date = try  container.decode(String.self,forKey: .date)
        self.commentsi = try? container.decode(CommentsSet?.self,forKey: .commentsi)
       
        
    }
    

    
    
    func nbLike() -> Int {
        var res: Int = 0
        let group = DispatchGroup()
        group.enter()
        if let url = URL(string: "http://51.255.175.118:2000/opinion/post/"+String(self.post_id)) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let tmp = try JSONDecoder().decode([Opinion].self, from: data)
                        res = tmp.count
                        
                        group.leave()
                    } catch let error {
                        res = 0								
                    }
                }
            }.resume()
        }
        group.wait()
        return res
    }
}
