//
//  post.swift
//  mobile_IG4
//
//  Created by user165108 on 25/02/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import Foundation


class Post : Identifiable, Decodable {
    var post_id: Int
    var title : String
    var description : String
    var post_category : Int
    var author : Int
    var url_image : String
    var date : String
    
    init(post_id : Int, title : String, description : String, post_category : Int, author : Int, url_image : String, date : String){
        self.post_id = post_id
        self.title = title
        self.description = description
        self.post_category = post_category
        self.author = author
        self.url_image = url_image
        self.date = date
    }
}
