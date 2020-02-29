//
//  loginView.swift
//  mobile_IG4
//
//  Created by user165108 on 27/02/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import SwiftUI



struct addPostView: View {
    @Environment(\.presentationMode) var presentationMode
    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    init(postsObserved : PostSet){
        self.postsObserved = postsObserved
    }
    var postsObserved : PostSet
    @State var title: String = ""
    @State var description: String = ""
   
    struct Response :Decodable {
        var result: Bool
        var id: Int
    }
    
    func addPost(title: String,description: String){
       
        
        let post = AddPostForm(title: title, description: description, username: "T")
        guard let encoded = try? JSONEncoder().encode(post) else {
            print("Failed to encode order")
            return
        }
        var isCreate = false
        var id = 0
        let group = DispatchGroup()
        group.enter()
        if let url = URL(string: "http://51.255.175.118:2000/post/create") {
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Application")
            request.httpMethod = "POST"
            request.httpBody = encoded
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                        let res = try? JSONDecoder().decode(Response.self, from: data)
                        if let res2 = res{
                            print(res2.result)
                            if(res2.result == true){
                                isCreate = true
                                id=res2.id
                            }
                        }else{
                            print("error")
                        }
                        group.leave()
    
                }
            }.resume()
        }
        group.wait()
        if(isCreate == true){
            let postToAdd = Post(post_id: id, title: title, description: description, post_category: 1, author: 1, url_image: "", date: "")
            self.postsObserved.add(post: postToAdd)
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    var body: some View {
        VStack {
            Text("Add a new post !")
            TextField("Title" , text: $title)
            .padding()
            .background(lightGreyColor)
                .cornerRadius(5.0)
                .padding(.bottom,20)
            TextField("Description" , text: $description)
            .padding()
            .background(lightGreyColor)
                .cornerRadius(5.0)
                .padding(.bottom,20)
            
            
            
            Button(action: {self.addPost(title: self.title,description: self.description)}) {
               Text("Add")
               .font(.headline)
               .foregroundColor(.white)
               .padding()
               .frame(width: 220, height: 60)
               .background(Color.green)
               .cornerRadius(15.0)
            }
        
        }.padding()
    }
}




