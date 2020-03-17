//
//  post.swift
//  mobile_IG4
//
//  Created by user165108 on 25/02/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import Foundation


class Comment : ObservableObject, Identifiable, Codable {
    var comment_id: Int
    
    var description : String
    var comment_category : Int
    var author : Int
    var post : Int
    var date : String
    var username : String
    var like : Int
    var dislike : Int
    var category_description : String
    //var color : String
    
    
    init(comment_id : Int, description : String, comment_category : Int, author : Int, post : Int, date : String, username : String, like : Int, dislike : Int){
        self.comment_id = comment_id
        self.description = description
        self.comment_category = comment_category
        self.author = author
        self.post = post
        self.date = date
        self.username = username
        self.like = like
        self.dislike = dislike
        self.category_description = "new"
        //self.color = "#00FF00"
    }
}
