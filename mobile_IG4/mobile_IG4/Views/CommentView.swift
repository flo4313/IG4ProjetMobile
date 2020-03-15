//
//  CommentView.swift
//  mobile_IG4
//
//  Created by user165108 on 14/03/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import Foundation
import SwiftUI

struct CommentView : View{
    @ObservedObject var comment : Comment
    @ObservedObject var already = Already()
    var config = Config()
    var rateCommentDAL = RateCommentDAL()
    @EnvironmentObject var user : User
    
    init(comment : Comment) {
        self.comment = comment
    }
    var body: some View {
        VStack{
            HStack {
                //username and date
                Text(comment.username)
                Spacer()
                Text(comment.date.split(separator: "T")[0].split(separator: " ")[0].replacingOccurrences(of: "-", with: "/"))
            }.padding(10).background(config.postbarColor())
            HStack{
                //Comment
                Text(comment.description)
                Spacer()
            }.padding([.horizontal], 10).padding([.top], 4).fixedSize(horizontal: false, vertical: true)
            HStack {
                //like and report
                HStack {
                    Button(action: {
                        self.rateCommentDAL.rate(user: self.user, comment: self.comment, like: 1)
                        self.already.liked = !self.already.liked
                        self.already.disliked = false
                    }) {
                        if (self.already.liked) {
                            Image("upArrowLiked").resizable().frame(width: 12, height : 12)
                        } else {
                            Image("upArrow").resizable().frame(width: 12, height : 12)
                        }
                    }
                    Text("\(comment.like - comment.dislike)").font(.system(size: 15))
                    Button(action: {
                        self.rateCommentDAL.rate(user: self.user, comment: self.comment, like: 0)
                        self.already.disliked = !self.already.disliked
                        self.already.liked = false
                    }) {
                        if (self.already.disliked) {
                            Image("downArrowDisliked").resizable().frame(width: 12, height : 12)
                        } else {
                            Image("downArrow").resizable().frame(width: 12, height : 12)
                        }
                    }
                    Spacer()
                    Button(action: {print("TODO report")}) {
                        Image("warning").resizable().frame(width: 15, height : 15)
                    }
                    
                }.buttonStyle(PlainButtonStyle()).onAppear() {
                    if(self.rateCommentDAL.hasRated(user: self.user, comment: self.comment) == 1) {
                        self.already.liked = true
                    } else if (self.rateCommentDAL.hasRated(user: self.user, comment: self.comment) == 0) {
                        self.already.disliked = true
                    }
                }
            }.padding([.vertical], 6).padding([.horizontal], 15)
        }.background(config.postColor()).cornerRadius(15.0)
    }
}
