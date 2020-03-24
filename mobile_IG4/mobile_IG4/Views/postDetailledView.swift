//
//  postDetailledView.swift
//  mobile_IG4
//
//  Created by user165108 on 28/02/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import SwiftUI

struct post : View{
    var postElt : Post
    @EnvironmentObject var user : User
    @ObservedObject var already: Already
    @State private var showingLoginAlert = false
    private var opinionDAL : OpinionDAL = OpinionDAL()
    private var reportPostDAL : ReportPostDAL = ReportPostDAL()
    @ObservedObject var imageLoader : ImageLoader
    var config = Config()
    
    func sendLike(){
        opinionDAL.like(user: self.user, post: self.postElt)
    }
    init(postElt : Post, already : Already){
        self.postElt = postElt
        self.already = already
   
        self.imageLoader = ImageLoader(urlString:"https://thomasfaure.fr/" + postElt.url_image)
     
    }
    func imageFromData(_ data:Data) ->UIImage{
        UIImage(data: data) ?? UIImage()
    }

    
    
    var body: some View {
        HStack{

        VStack{
                HStack{
                    HStack {
                        Text(self.postElt.title)
                            .font(.title)
                            .fontWeight(.light)
                            .foregroundColor(Color.black)
                            .multilineTextAlignment(.leading)
                            .padding([.horizontal])
                        Spacer()
                        Text("#\(self.postElt.post_id)")
                            .padding([.horizontal])
                    }.background(config.postbarColor()).cornerRadius(5.0)
                }.padding([.horizontal])
                
                HStack {
                    Spacer()
                    VStack{
                    if (self.postElt.url_image != ""){
                    Image(uiImage: imageLoader.dataIsValid ? imageFromData(imageLoader.data!) : UIImage()).resizable().aspectRatio(contentMode: .fit).frame(width:250,height:250)
                    }
                    Text(self.postElt.description)
                    .multilineTextAlignment(.leading)
                    }
                    Spacer()
                }.padding([.horizontal], 20).padding([.vertical], 15)
                HStack(){
                    Spacer()
                    if(self.user.isLogged) {
                        if(self.already.liked) {
                            Button(action: {
                                    self.sendLike()
                                    self.already.liked = !self.already.liked
                            }) {
                                Text("\(self.postElt.like)").foregroundColor(Color.yellow)
                                Image("earLiked").resizable().frame(width: 30, height: 30)
                            }.buttonStyle(PlainButtonStyle())
                            
                        } else {
                            Button(action: {
                                    self.sendLike()
                                    self.already.liked = !self.already.liked
                            }) {
                                Text("\(self.postElt.like)")
                                Image("ear").resizable().frame(width: 30, height: 30)
                            }
                        }
                    } else {
                        Button(action: {
                            self.showingLoginAlert = true
                        }) {
                            Text("\(self.postElt.like)")
                            Image("ear").resizable().frame(width: 30, height: 30)
                        }.alert(isPresented: $showingLoginAlert) {
                            Alert(title: Text("Login"), message: Text("You must be logged to perform this action"), dismissButton: .default(Text("Got it!")))
                        }
                    }
                    Spacer()
                    if(self.user.isLogged){
                        if(self.already.reported) {
                            Button(action: {
                                self.reportPostDAL.sendReport(user : self.user, postElt : self.postElt)
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
                                    self.reportPostDAL.sendReport(user : self.user, postElt : self.postElt)
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
                    Spacer()
                }.padding([.horizontal], 40).padding([.vertical], 5).background(config.postbarColor())
            }.padding([.top],10).background(config.postColor()).cornerRadius(5.0).buttonStyle(PlainButtonStyle())
            Spacer()
        }.padding().onAppear{
            if(self.reportPostDAL.hasReported(user: self.user, postElt: self.postElt)) {
                self.already.reported = true
            }
            if(self.opinionDAL.hasLiked(user: self.user, post: self.postElt)) {
                self.already.liked = true
            }
        }.shadow(color: Color.black.opacity(0.3),
        radius: 3,
        x: 3,
        y: 3)
      
    }
}


struct comments : View{
    @ObservedObject var commentsList : CommentsSet
    var user : User
    var already : [Already]
    var rateCommentDAL = RateCommentDAL()
    var reportCommentDAL = ReportCommentDAL()
    
    
    init(commentsState : CommentsSet, user : User){
        self.commentsList = commentsState
        self.user = user
        
        if(commentsState.data.count > 0) {
            self.already = (0...commentsState.data.count - 1).map{_ in Already()}
            
            for i in 0...self.already.count - 1 {
                if(self.user.isLogged) {
                    if(self.rateCommentDAL.hasRated(user: self.user, comment: commentsState.data[i]) == 1) {
                        self.already[i].liked = true
                    } else if (self.rateCommentDAL.hasRated(user: self.user, comment: commentsState.data[i]) == 0) {
                        self.already[i].disliked = true
                    }
                    
                    if(self.reportCommentDAL.hasReported(user: self.user, comment: commentsState.data[i])) {
                        self.already[i].reported = true
                    }
                }
            }
        } else {
            self.already = []
        }
        
        
    }
     
    
    var body: some View {
        VStack{
            Text("il y a "+String(commentsList.data.count)+" réponse(s)")
            VStack {
                if(self.commentsList.data.count > 0)  {
                    ForEach(0...commentsList.data.count - 1, id: \.self) {
                        i in
                        CommentView(comment: self.commentsList.data[i], already: self.already[i]).padding()
                    }
                }
            }.padding(.bottom, 20.0)
        }
    }
}

struct inputComment : View{
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var user : User
    var config = Config()
    @State var isChecked:Bool = false
    
    
    @ObservedObject var post : Post
    @State private var message: String = " "
      let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    struct AddCommentForm : Codable {
        var description : String
        var post_id : Int
        var category : Int
        var anonyme : Bool
    }
    struct Response :Decodable {
        var result: Bool
        var id: Int
    }
    
    func sendNewComment(){
        if let author = user.user {
            let comment = Comment(comment_id: 1, description: self.message, comment_category: 11, author: author.user_id, post: 1, date: Date().description, username: author.username, like : 0, dislike : 0,anonyme:(self.isChecked == true ? 1 : 0),color: "#ffffff")
            
            let commentF = AddCommentForm(description: self.message,post_id: self.post.post_id, category: 11,anonyme: self.isChecked)
                guard let encoded = try? JSONEncoder().encode(commentF) else {
                    print("Failed to encode order")
                    return
                }
                var isCreate = false
                let group = DispatchGroup()
                group.enter()
            if let url = URL(string:   "https://thomasfaure.fr/post/"+String(self.post.post_id)+"/comment/create") {
                    var request = URLRequest(url: url)
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue("application/json", forHTTPHeaderField: "Application")
                    request.setValue("Bearer "+user.token,forHTTPHeaderField: "Authorization")
                    request.httpMethod = "POST"
                    request.httpBody = encoded
                    
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        if let data = data {
                                let res = try? JSONDecoder().decode(Response.self, from: data)
                                if let res2 = res{
                                    if(res2.result == true){
                                        isCreate = true
                                        comment.comment_id = res2.id
                                        print("created !")
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
                    self.message = ""
                    self.post.objectWillChange.send()
                    self.post.commentsi!.data.append(comment)
                  
                }
        }
        
        
    }
    func toggle(){isChecked = !isChecked}
    
    var body: some View{
        HStack{
            Spacer()
            if(user.isLogged){
                Button(action: self.toggle){
                    Image(self.isChecked ? "checked" : "notChecked").resizable().frame(width:25,height: 25)
                    Text("anonymous ?")
                }.foregroundColor(.black)
                TextField("Enter a comment", text:$message)
                    .padding()
                    .background(lightGreyColor)
                Button(action: {self.sendNewComment()}) {
                   Image("send")
                    .resizable()
                    .frame(width: 30, height: 30)
                   .foregroundColor(.white)
                   .padding()
                   .background(Color.green)
                   .cornerRadius(15.0)
                }
                Spacer()
            } else {
                VStack {
                    Text("Login to answer !").padding()
                    HStack {
                        NavigationLink(destination: loginView()) {
                            Text("Login")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 140, height: 40)
                                .background(Color.green)
                                .cornerRadius(15.0)
                                .padding(.bottom,10)
                            .shadow(color: Color.black.opacity(0.3),
                            radius: 3,
                            x: 3,
                            y: 3)
                        }
                        NavigationLink(destination: registerView()) {
                            Text("Register")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 140, height: 40)
                                .background(Color.green)
                                .cornerRadius(15.0).padding(.bottom,10)
                            .shadow(color: Color.black.opacity(0.3),
                            radius: 3,
                            x: 3,
                            y: 3)
                        }
                    }
                }
            }
            Spacer()
            }.padding(3).background(config.postbarColor())
    }
}
struct postDetailledView: View {
    var commentsState : CommentsSet
    @EnvironmentObject var user : User
    @ObservedObject var postElt : Post
    @ObservedObject var already : Already
    
    init(postEl : Post, already: Already){
        
        self.postElt = postEl
        self.commentsState = postEl.commentsi!
        self.already = already
     
        
        
    }
    
    
    var body: some View {
        VStack{
            ScrollView {
                post(postElt: postElt, already: already)
                comments(commentsState: commentsState, user : user)
                
            }
        Spacer()
            inputComment(post: postElt)
        }
    }
}


