//
//  PostSet.swift
//  mobile_IG4
//
//  Created by user165108 on 25/02/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import Foundation

class PostSet : Identifiable {
    var data: Array<Post>
    
    init(){
        self.data = Array()
        let jsonData = getJSON()
        for post in jsonData {
            self.data.append(post)
        }
    }
    
    func getJSON() -> [Post] {
        var res: [Post] = []
        let group = DispatchGroup()
        group.enter()
        if let url = URL(string: "http://51.255.175.118:2000/post") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        res = try JSONDecoder().decode([Post].self, from: data)
                        print(res)
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
