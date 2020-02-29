//
//  PostSet.swift
//  mobile_IG4
//
//  Created by user165108 on 25/02/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import Foundation

class CommentsSet : ObservableObject {
    @Published var data: Array<Comment>
    var post_id : Int
    init(post_id : Int){
        self.post_id = post_id
        self.data = Array()
        let jsonData = getJSON(post_id: post_id)
        for comment in jsonData {
            self.data.append(comment)
        }
    }

    
    func getJSON(post_id: Int) -> [Comment] {
        var res: [Comment] = []
        let group = DispatchGroup()
        group.enter()
        if let url = URL(string: "http://51.255.175.118:2000/post/"+String(post_id)+"/comments") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        res = try JSONDecoder().decode([Comment].self, from: data)
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
