//
//  PostSet.swift
//  mobile_IG4
//
//  Created by user165108 on 25/02/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import Foundation
import Combine
class PostSet : ObservableObject {

    
    @Published var data: Array<Post> {
        willSet{
            objectWillChange.send()
        }
    }
    
    func add(post : Post){
        self.data.append(post)
    }
    
    init(search: Bool){
        self.data = Array()
        if search {
        let jsonData = getJSON()
        for post in jsonData {
            self.data.append(post)
            
        }
        }
    }
    
    func setData(){
        self.data.removeAll()
        let jsonData = getJSON()
        for post in jsonData {
            self.data.append(post)
            
        }
        
    }
    
    func getJSON() -> [Post] {
        var res: [Post] = []
        let group = DispatchGroup()
        group.enter()
        if let url = URL(string: "https://thomasfaure.fr/post") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        res = try JSONDecoder().decode([Post].self, from: data)
                        group.leave()
                    } catch let error {
                        print(error)
                    }
                }
            }.resume()
        }
        group.wait()
        for post in res{
            post.setComments()
        }
        return res
    }
}
