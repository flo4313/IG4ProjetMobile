//
//  CommentCategory.swift
//  mobile_IG4
//
//  Created by user165108 on 27/03/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import Foundation

class CommentCategory : Identifiable, Decodable {
    var comment_category_id: Int
    var description : String
    var color : String
    
    init(comment_category_id: Int, description: String, couleur: String) {
        self.comment_category_id = comment_category_id
        self.description = description
        self.color = couleur
    }

}
