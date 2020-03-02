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
    var post: Post
    @ObservedObject var commentsList : CommentsSet
    
    init(post: Post){
        self.post = post
        self.commentsList = CommentsSet(post_id: post.post_id)
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
                            
                            HStack {
                                Text(self.post.description)
                                .multilineTextAlignment(.leading)
                                Spacer()
                            }.padding([.horizontal], 20).padding([.vertical], 15)
                            HStack(){
                                Text("\(self.post.nbLike())")
                                Image("ear").resizable().frame(width: 30, height: 30)
                                Spacer()
                                Text("\(self.commentsList.data.count)")
                                Image("comment").resizable().frame(width: 30, height: 30)
                                Spacer()
                                Image("warning").resizable().frame(width: 30, height: 30)
                            }.padding([.horizontal], 40).padding([.vertical], 5).background(Color.green)
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

struct SwiftUICellView_Previews: PreviewProvider {
    static var previews: some View {
        postView(post: Post(post_id: 1, title: "foo", description: "foofoofoo", post_category: 1, author: 1, url_image: "urlfoo", date: "01/01/2000"))
    }
}
