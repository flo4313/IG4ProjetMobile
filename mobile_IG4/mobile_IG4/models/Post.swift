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
    var url_image : String = "" 
    var date : String = ""
    var like : Int = 0
    var comment : Int = 0
    var username : String
    
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
        case comment
        case like
        case commentsi
        case username
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
        self.comment = try container.decode(Int.self, forKey: .comment)
        self.like = try container.decode(Int.self, forKey: .like)
        self.commentsi = try? container.decode(CommentsSet?.self,forKey: .commentsi)
        self.username = try container.decode(String.self, forKey: .username)
        
    }
    
}
