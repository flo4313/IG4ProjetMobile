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
    
    var commentsState : CommentsSet
    @State private var message: String = " "
      let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    
    func sendNewComment(){
        let comment = Comment(comment_id: 2, description: self.message, comment_category: 1, author: 1, post: 1, date: "")
        print("add: "+self.message)
        commentsState.data.append(comment)
        print(commentsState.data.count)
        
    }
    var body: some View{
        HStack{
            TextField("Enter your name", text:$message)
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
        inputComment(commentsState: commentsState)
        }
    }
}


