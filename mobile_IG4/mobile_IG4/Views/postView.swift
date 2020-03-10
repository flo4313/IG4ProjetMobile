//
//  postView.swift
//  mobile_IG4
//
//  Created by user165108 on 25/02/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import SwiftUI

struct postView: View {
    let blue = Color(red: 109.0/255.0, green: 201.0/255.0, blue: 234.0/255.0, opacity: 1.0)
    let red = Color(red: 234.0/255.0, green: 133.0/255.0, blue: 109.0/255.0, opacity: 0.8)
    @ObservedObject var post: Post
    @EnvironmentObject var user : User
    
    let imageLoader : ImageLoader
    init(post: Post){
        self.post = post
        
        imageLoader = ImageLoader(urlString: post.url_image)
    }
    func imageFromData(_ data:Data) ->UIImage{
        UIImage(data: data) ?? UIImage()
    }
    
    struct ToEncode : Codable{
        var author:Int
        var post:Int
    }
    struct Result: Decodable{
        var result : String
    }
    
    
    func sendLike(){
        var result = ""
        
        var user_id = 0
        if let tmp = self.user.user?.user_id {
            user_id = tmp
        }
        
        let group = DispatchGroup()
        group.enter()
        
        let encod = ToEncode(author: user_id, post: self.post.post_id)
        guard let encoded = try? JSONEncoder().encode(encod) else {
            print("Failed to encode order")
            return
        }
        if let url = URL(string: "http://51.255.175.118:2000/opinion/create") {
                    var request = URLRequest(url: url)
          
                    
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.httpMethod = "POST"
                    request.httpBody = encoded
        
                    URLSession.shared.dataTask(with: request) { data, response, error in
                       if let data = data {
                                           let res = try? JSONDecoder().decode(Result.self, from: data)
                                           if let res2 = res{
                                                result = res2.result
                                           }else{
                                               print("error")
                                           }
                                    group.leave()
                       
                                   }
                    }.resume()
        } else {
            print("Failed to acces URL")
        }
        group.wait()
        if(result == "liked") {
            self.post.objectWillChange.send()
            self.post.like += 1
        } else if(result == "deleted") {
            self.post.objectWillChange.send()
            self.post.like -= 1
        }
    }
    
    
    
     
    var body: some View {
        
        HStack(alignment: .bottom){
            HStack {
                VStack(alignment: .leading){
                    HStack {
                        VStack{
                            HStack{
                                HStack {
                                    Text(self.post.title)
                                        .font(.title)
                                        .fontWeight(.light)
                                        .foregroundColor(Color.black)
                                        .multilineTextAlignment(.leading)
                                        .padding([.horizontal])
                                    Spacer()
                                    Text("#\(self.post.post_id)")
                                        .padding([.horizontal])
                                }.background(Color.white).cornerRadius(5.0)
                                
                            }.padding([.horizontal])
                            Image(uiImage: imageLoader.dataIsValid ? imageFromData(imageLoader.data!) : UIImage()).resizable().aspectRatio(contentMode: .fit).frame(width:100,height:100)
                            HStack {
                                Text(self.post.description)
                                .multilineTextAlignment(.leading)
                                Spacer()
                            }.padding([.horizontal], 20).padding([.vertical], 15)
                            HStack(){
                                Button(action: {self.sendLike()}) {
                                    Text("\(self.post.like)")
                                    Image("ear").resizable().frame(width: 30, height: 30)
                                }
                                Spacer()
                                Button(action: {print("TODO comment")}) {
                                    Text("\(self.post.commentsi!.data.count)")
                                    Image("comment").resizable().frame(width: 30, height: 30)
                                }
                                Spacer()
                                Button(action: {print("TODO warning")}) {
                                    Image("warning").resizable().frame(width: 30, height: 30)
                                }
                            }.padding([.horizontal], 40).padding([.vertical], 5).background(Color.green).buttonStyle(PlainButtonStyle())
                    }.padding([.top],10).background(blue).cornerRadius(5.0)
                    
                    }
                        
                    
                     HStack(){
                        HStack{
                        VStack{
                            Text("Best answer")
                                .font(.footnote)
                        }
                            Spacer()
                            
                            }.padding().background(red).cornerRadius(5.0)
                     }.padding(.leading,50)


            }
        }
            }.padding()
    }
}

