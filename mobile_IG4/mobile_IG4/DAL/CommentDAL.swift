//
//  CommentDAL.swift
//  mobile_IG4
//
//  Created by user165108 on 29/03/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import Foundation
class CommentDAL {
    
    struct ResultDelete : Decodable {
        var affectedRows: Int
        
    }

    func delete(comment : Comment, user : User) -> Bool{
        var isDeleted = false
        let group = DispatchGroup()
            group.enter()
        if let url = URL(string: "https://thomasfaure.fr/comment/\(comment.comment_id)/delete") {
                var request = URLRequest(url: url)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json", forHTTPHeaderField: "Application")
                request.setValue("Bearer "+user.token,forHTTPHeaderField: "Authorization")
                request.httpMethod = "DELETE"
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let data = data {
                        let res = try? JSONDecoder().decode(ResultDelete.self, from: data)
                        if let res2 = res{
                            print(res2.affectedRows)
                            if(res2.affectedRows == 1){
                                isDeleted = true
                                
                            }
                        }else{
                            print("error")
                        }
                        group.leave()
                        
                    }
                }.resume()
            }
            group.wait()
        return isDeleted
    }
}
