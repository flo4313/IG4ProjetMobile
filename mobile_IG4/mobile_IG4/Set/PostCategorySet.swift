//
//  postCategoryCategorySet.swift
//  mobile_IG4
//
//  Created by user165108 on 25/02/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import Foundation

class PostCategorySet : Identifiable {
    var data: Array<PostCategory>
    
    init(){
        self.data = Array()
        let jsonData = getJSON()
        for postCategory in jsonData {
            self.data.append(postCategory)
        }
    }
    
    func getJSON() -> [PostCategory] {
        var res: [PostCategory] = []
        let group = DispatchGroup()
        group.enter()
        if let url = URL(string: "http://51.255.175.118:2000/postCategory") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        res = try JSONDecoder().decode([PostCategory].self, from: data)
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
