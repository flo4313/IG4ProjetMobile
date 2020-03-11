//
//  postView.swift
//  mobile_IG4
//
//  Created by user165108 on 25/02/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import SwiftUI

struct postView: View {

    private var config : Config = Config()
    @ObservedObject var post: Post
    @EnvironmentObject var user : User
    private var opinionDAL : OpinionDAL = OpinionDAL()
    
    let imageLoader : ImageLoader
    init(post: Post){
        self.post = post
        imageLoader = ImageLoader(urlString: post.url_image)
    }
    func imageFromData(_ data:Data) ->UIImage{
        UIImage(data: data) ?? UIImage()
    }
    
   
    
    func sendLike(){
        opinionDAL.like(user: self.user, post: self.post)
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
                                }.background(config.postbarColor()).cornerRadius(5.0)
                                
                            }.padding([.horizontal])
                            
                            if (self.post.url_image != ""){
                            Image(uiImage: imageLoader.dataIsValid ? imageFromData(imageLoader.data!) : UIImage()).resizable().aspectRatio(contentMode: .fit).frame(width:100,height:100)
                            }
                            
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
                            }.padding([.horizontal], 40).padding([.vertical], 5).background(config.postbarColor()).buttonStyle(PlainButtonStyle())
                        }.padding([.top],10).background(config.postColor()).cornerRadius(5.0)
                    
                    }
                        
                    
                     HStack(){
                        HStack{
                        VStack{
                            Text("Best answer")
                                .font(.footnote)
                        }
                            Spacer()
                            
                        }.padding().background(config.answerColor()).cornerRadius(5.0)
                     }.padding(.leading,50)


            }
        }
        }.padding()
    }
}

