//
//  PostCategory.swift
//  mobile_IG4
//
//  Created by user165108 on 25/02/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import Foundation


class PostCategory : Identifiable, Decodable {
    var post_category_id: Int
    var description : String
    var couleur : String
    
    init(post_category_id: Int, description: String, couleur: String) {
        self.post_category_id = post_category_id
        self.description = description
        self.couleur = couleur
    }

}
