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
    @ObservedObject var already: Already
    private var opinionDAL : OpinionDAL = OpinionDAL()
    var reportPostDAL : ReportPostDAL = ReportPostDAL()
    let imageLoader : ImageLoader
    
    init(post: Post, already : Already){
        self.post = post
        self.already = already
        imageLoader = ImageLoader(urlString:"http://51.255.175.118:2000/" + post.url_image)
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
                            HStack {
                                Text(self.post.username)
                                Spacer()
                                Text(self.post.date.split(separator: "T")[0].replacingOccurrences(of: "-", with: "/"))
                            }.padding([.horizontal], 20).padding([.bottom], 10)
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
                                if(self.already.liked) {

                                    Button(action: {
                                        self.sendLike()
                                        self.already.liked = !self.already.liked
                                    }) {
                                        Text("\(self.post.like)").foregroundColor(Color.yellow)
                                        Image("earLiked").resizable().frame(width: 30, height: 30)
                                    }.buttonStyle(PlainButtonStyle())
                                    
                                } else {
                                    Button(action: {
                                        self.sendLike()
                                        self.already.liked = !self.already.liked
                                    }) {
                                        Text("\(self.post.like)")
                                        Image("ear").resizable().frame(width: 30, height: 30)
                                    }
                                }
                                Spacer()
                                HStack{
                                    Text("\(self.post.commentsi!.data.count)")
                                    Image("comment").resizable().frame(width: 30, height: 30)
                                }
                                Spacer()
                                if(self.already.reported) {
                                    Button(action: {
                                        self.reportPostDAL.sendReport(user : self.user, postElt : self.post)
                                        self.already.reported = !self.already.reported
                                    }) {
                                    Image("warning")
                                     .resizable()
                                     .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.red)
                                    .cornerRadius(15.0)
                                    }
                                } else {
                                    Button(action: {
                                        self.reportPostDAL.sendReport(user : self.user, postElt : self.post)
                                        self.already.reported = !self.already.reported
                                    }) {
                                    Image("warning")
                                     .resizable()
                                     .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                                    .padding()
                                    .cornerRadius(15.0)
                                    }
                                }
                            }.padding([.horizontal], 40).padding([.vertical], 5).background(config.postbarColor()).buttonStyle(PlainButtonStyle()).onAppear(){
                                if(self.reportPostDAL.hasReported(user: self.user, postElt: self.post)) {
                                    self.already.reported = true
                                }
                                if(self.opinionDAL.hasLiked(user: self.user, post: self.post)) {
                                    self.already.liked = true
                                }
                            }
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

