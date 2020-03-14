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
    private var opinionDAL : OpinionDAL = OpinionDAL()
    private var reportPostDAL : ReportPostDAL = ReportPostDAL()
    
    func sendLike(){
        opinionDAL.like(user: self.user, post: self.postElt)
    }
    
    init(postElt : Post, already : Already){
        self.postElt = postElt
        self.already = already
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
                    }.background(Color.white).cornerRadius(5.0)
                }.padding([.horizontal])
                
                HStack {
                    Text(self.postElt.description)
                    .multilineTextAlignment(.leading)
                    Spacer()
                }.padding([.horizontal], 20).padding([.vertical], 15)
                HStack(){
                    Spacer()
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
                    Spacer()
                    if(self.already.reported == true){
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
                    }else{
                        Button(action: {
                            self.reportPostDAL.sendReport(user : self.user, postElt : self.postElt)
                            self.already.reported = !self.already.reported
                        }) {
                        Image("warning")
                         .resizable()
                         .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(15.0)
                        }
                    }
                    Spacer()
                }.padding([.horizontal], 40).padding([.vertical], 5).background(Color.green)
        }.padding([.top],10).background(Color.blue).cornerRadius(5.0)
            Spacer()
        }.padding().onAppear{
            if(self.reportPostDAL.hasReported(user: self.user, postElt: self.postElt)) {
                self.already.reported = true
            }
            if(self.opinionDAL.hasLiked(user: self.user, post: self.postElt)) {
                self.already.liked = true
            }
        }
      
    }
}


struct comments : View{
    @ObservedObject var commentsList : CommentsSet
    init(commentsState : CommentsSet){
        self.commentsList = commentsState
    }
     
    
    var body: some View {
        VStack{
            Text("il y a "+String(commentsList.data.count)+" réponse(s)")
            List {
                ForEach(commentsList.data) {
                    comment in
                    CommentView(comment: comment)
                }
            }
            .padding(.bottom, 20.0)
        }
    }
}

struct inputComment : View{
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var user : User
    
    
    @ObservedObject var post : Post
    @State private var message: String = " "
      let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    struct AddCommentForm : Codable {
        var description : String
        var post_id : Int
        var category : Int
    }
    struct Response :Decodable {
        var result: Bool
    }
    
    func sendNewComment(){
        if let user_id = user.user?.user_id {
            let comment = Comment(comment_id: 1, description: self.message, comment_category: 11, author: user_id, post: 1, date: "")
            
            let commentF = AddCommentForm(description: self.message,post_id: self.post.post_id, category: 11)
                guard let encoded = try? JSONEncoder().encode(commentF) else {
                    print("Failed to encode order")
                    return
                }
                var isCreate = false
                let group = DispatchGroup()
                group.enter()
            if let url = URL(string: "http://51.255.175.118:2000/post/"+String(self.post.post_id)+"/comment/create") {
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
                                    print(res2.result)
                                    if(res2.result == true){
                                        isCreate = true
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
    var body: some View{
        HStack{
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
            
        }
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
        post(postElt: postElt, already: already)
        comments(commentsState: commentsState)
        Spacer()
            inputComment(post: postElt)
        }
    }
}


