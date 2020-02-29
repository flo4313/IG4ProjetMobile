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
    var body: some View {
        HStack{
            Text("Post:")
            Spacer()
        VStack{
            Text(String(postElt.author))
            Text(postElt.title)
            }
            Spacer()
        }.background(Color(red: 188 / 255, green: 188 / 255, blue: 188 / 255))
      
    }
}


struct CommentView : View{
    var comment : Comment
    var body: some View {
        Text(comment.description)
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
    init(commentsState:CommentsSet,post_id: Int){
        self.post_id = post_id
        self.commentsState = commentsState
    }
    var post_id : Int
    var commentsState : CommentsSet
    @State private var message: String = " "
      let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    struct AddCommentForm : Codable {
        var description : String
        var post : Int
        var username : String
    }
    struct Response :Decodable {
        var result: Bool
    }
    func sendNewComment(){
        let comment = Comment(comment_id: 1, description: self.message, comment_category: 1, author: 1, post: 1, date: "")
        
        let commentF = AddCommentForm(description: self.message,post: self.post_id, username: "T")
            guard let encoded = try? JSONEncoder().encode(commentF) else {
                print("Failed to encode order")
                return
            }
            var isCreate = false
            let group = DispatchGroup()
            group.enter()
        if let url = URL(string: "http://51.255.175.118:2000/post/"+String(self.post_id)+"/comment/create") {
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
                commentsState.data.append(comment)
                print(commentsState.data.count)
            }
        
        
    }
    var body: some View{
        HStack{
            TextField("Enter a comment", text:$message)
                .padding()
                .background(lightGreyColor)
            Button(action: {self.sendNewComment()}) {
               Text("+")
               .font(.headline)
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
    @ObservedObject var commentsState : CommentsSet
   
    init(postElt : Post){
        print("go")
        self.postElt = postElt
        commentsState = CommentsSet(post_id: self.postElt.post_id)
    }
    
    var postElt : Post
    var body: some View {
        VStack{
        post(postElt: postElt)
        comments(commentsState: commentsState)
        Spacer()
            inputComment(commentsState: commentsState,post_id : postElt.post_id)
        }
    }
}


