//
//  Opinion.swift
//  mobile_IG4
//
//  Created by user165108 on 02/03/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import Foundation

class Opinion : Decodable {
    var author: Int
    var post : Int
    var like : Int

    init(author : Int, post : Int, like : Int){
        self.author = author
        self.post = post
        self.like = like
    }
}
