//
//  postCategoryDal.swift
//  mobile_IG4
//
//  Created by etud on 12/03/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import Foundation

class CommentCategoryDAL{
    var data: Array<CommentCategory>
    
    init(){
        self.data = Array()
        let jsonData = getJSON()
        for postCategory in jsonData {
            self.data.append(postCategory)
        }
    }
    
    func getJSON() -> [CommentCategory] {
        var res: [CommentCategory] = []
        let group = DispatchGroup()
        group.enter()
        if let url = URL(string: "https://thomasfaure.fr/commentCategory") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        res = try JSONDecoder().decode([CommentCategory].self, from: data)
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
