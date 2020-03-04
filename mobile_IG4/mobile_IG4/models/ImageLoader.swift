//
//  ImageLoader.swift
//  mobile_IG4
//
//  Created by Thomas Faure on 04/03/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import Foundation

class ImageLoader: ObservableObject{
    @Published var dataIsValid = false
    var data:Data?
    
    init(urlString:String){
        guard let url = URL(string: urlString) else { return}
        let task = URLSession.shared.dataTask(with: url) { data,response, error in
            guard let data = data else {return}
            DispatchQueue.main.async{
                self.dataIsValid = true
                self.data = data
            }
        }
        task.resume()
    }
}
