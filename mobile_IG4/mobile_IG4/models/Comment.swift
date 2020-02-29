//
//  post.swift
//  mobile_IG4
//
//  Created by user165108 on 25/02/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import Foundation


class Comment : Identifiable, Decodable {
    var comment_id: Int
    
    var description : String
    var comment_category : Int
    var author : Int
    var post : Int
    var date : String
    
    init(comment_id : Int, description : String, comment_category : Int, author : Int, post : Int, date : String){
        self.comment_id = comment_id
        self.description = description
        self.comment_category = comment_category
        self.author = author
        self.post = post
        self.date = date
    }
}
