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
    @State private var showingLoginAlert = false
    var config = Config()
    var rateCommentDAL = RateCommentDAL()
    var reportCommentDAL = ReportCommentDAL()
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
                //Text(comment.category_description).background(Color.red).cornerRadius(10.0)
            }.padding(10).background(config.postbarColor())

            HStack{
                //Comment
                Text(comment.description)
                Spacer()
            }.padding([.horizontal], 10).padding([.top], 4).fixedSize(horizontal: false, vertical: true)
            HStack {
                //like and report
                HStack {
                    if(self.user.isLogged) {
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
                        Button(action: {
                            self.reportCommentDAL.sendReport(user: self.user, comment: self.comment)
                            self.already.reported = !self.already.reported
                        }) {
                            if(already.reported) {
                                Image("warning").resizable().frame(width: 15, height : 15).padding(3).background(Color.red).cornerRadius(5.0)
                            } else {
                                Image("warning").resizable().frame(width: 15, height : 15).padding(3)
                            }
                            
                        }
                    } else {
                        Button(action: {
                            self.showingLoginAlert = true
                        }) {
                            Image("upArrow").resizable().frame(width: 12, height : 12)
                        }.alert(isPresented: $showingLoginAlert) {
                        Alert(title: Text("Login"), message: Text("You must be logged to perform this action"), dismissButton: .default(Text("Got it!")))
                        }
                            
                        Text("\(comment.like - comment.dislike)").font(.system(size: 15))
                        Button(action: {
                            self.showingLoginAlert = true
                        }) {
                            Image("downArrow").resizable().frame(width: 12, height : 12)
                        }.alert(isPresented: $showingLoginAlert) {
                        Alert(title: Text("Login"), message: Text("You must be logged to perform this action"), dismissButton: .default(Text("Got it!")))
                            }
                            
                        Spacer()
                            
                        Button(action: {
                            self.showingLoginAlert = true
                        }) {
                            Image("warning").resizable().frame(width: 15, height : 15).padding(3)
                        }.alert(isPresented: $showingLoginAlert) {
                        Alert(title: Text("Login"), message: Text("You must be logged to perform this action"), dismissButton: .default(Text("Got it!")))
                            }
                    }
                    
                }.buttonStyle(PlainButtonStyle()).onAppear() {
                    if(self.rateCommentDAL.hasRated(user: self.user, comment: self.comment) == 1) {
                        self.already.liked = true
                    } else if (self.rateCommentDAL.hasRated(user: self.user, comment: self.comment) == 0) {
                        self.already.disliked = true
                    }
                    
                    if(self.reportCommentDAL.hasReported(user: self.user, comment: self.comment)) {
                        self.already.reported = true
                    }
                }
            }.padding([.vertical], 6).padding([.horizontal], 15)
        }.background(config.postColor()).cornerRadius(15.0)
    }
}
