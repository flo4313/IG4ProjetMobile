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
    @State private var showingLoginAlert = false
    let decriptionBestAnswer : String
    private var opinionDAL : OpinionDAL = OpinionDAL()
    var reportPostDAL : ReportPostDAL = ReportPostDAL()
    let imageLoader : ImageLoader
    
    init(post: Post, already : Already, descriptionBestAnswer : String){
        self.post = post
        self.already = already
        imageLoader = ImageLoader(urlString:"https://thomasfaure.fr/" + post.url_image)
        self.decriptionBestAnswer = descriptionBestAnswer
        
    }
    
    func imageFromData(_ data:Data) ->UIImage{
        UIImage(data: data) ?? UIImage()
    }
   
    
    func sendLike(){
        opinionDAL.like(user: self.user, post: self.post)
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
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
                            HStack {
                                if(self.post.location.count > 1){
                                    Text("🗺️: "+self.post.location)
                                }
                                Spacer()
                                Circle().fill(Color(self.hexStringToUIColor(hex: self.post.couleur))).frame(width: 25,height: 25)
                                
                                
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
                            }.padding([.horizontal], 20).padding([.vertical], 15).fixedSize(horizontal: false, vertical: true)
                            HStack(){
                                if(self.user.isLogged) {
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
                                } else {
                                    Button(action: {
                                        self.showingLoginAlert = true
                                    }) {
                                        Text("\(self.post.like)")
                                        Image("ear").resizable().frame(width: 30, height: 30)
                                    }.alert(isPresented: $showingLoginAlert) {
                                        Alert(title: Text("Login"), message: Text("You must be logged to perform this action"), dismissButton: .default(Text("Got it!")))
                                    }
                                }
                                Spacer()
                                HStack{
                                    Text("\(self.post.commentsi!.data.count)").fixedSize(horizontal: true, vertical: false)
                                    Image("comment").resizable().frame(width: 30, height: 30)
                                }
                                Spacer()
                                if(self.user.isLogged){
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
                                } else {
                                    Button(action: {
                                        self.showingLoginAlert = true
                                    }) {
                                    Image("warning")
                                     .resizable()
                                     .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                                    .padding()
                                    .cornerRadius(15.0)
                                    }.alert(isPresented: $showingLoginAlert) {
                                        Alert(title: Text("Login"), message: Text("You must be logged to perform this action"), dismissButton: .default(Text("Got it!")))
                                    }
                                }
                            }.padding([.horizontal], 40).padding([.vertical], 5).background(config.postbarColor()).buttonStyle(PlainButtonStyle())
                        }.padding([.top],10).background(config.postColor()).cornerRadius(5.0).shadow(color: Color.black.opacity(0.3),
                        radius: 3,
                        x: 3,
                        y: 3)
                    
                    }
                        
                    if(self.decriptionBestAnswer != "") {
                         HStack(){
                            HStack{
                                VStack{
                                    Text("Best answer : \n \(self.decriptionBestAnswer)")
                                        .font(.footnote)
                                }
                                Spacer()
                                
                            }.padding().background(config.answerColor()).cornerRadius(5.0)
                         }.padding(.leading,50).shadow(color: Color.black.opacity(0.3),
                         radius: 3,
                         x: 3,
                         y: 3)
                    }


            }
        }
        }.padding()
    }
}

