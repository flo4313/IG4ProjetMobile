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
    @ObservedObject var already : Already
    @ObservedObject var commentsList : CommentsSet
    @State private var showingLoginAlert = false
    var config = Config()
    var rateCommentDAL = RateCommentDAL()
    var reportCommentDAL = ReportCommentDAL()
    var commentDAL = CommentDAL()
    @EnvironmentObject var user : User
    
    init(comment : Comment, already : Already, commentList : CommentsSet) {
        self.comment = comment
        self.already = already
        self.commentsList = commentList
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
        VStack{
            VStack{
            HStack {
                //username and date
                Text((comment.anonyme == 1 ? "@anonyme" : "@"+comment.username))
                Spacer()
                Text(comment.date.split(separator: "T")[0].split(separator: " ")[0].replacingOccurrences(of: "-", with: "/"))
                if(self.user.isLogged && self.comment.author == self.user.user?.user_id) {
                    Button(action: {
                        if(self.commentDAL.delete(comment: self.comment, user: self.user)) {
                            print("deleted")
                            var cpt = 0
                            for cur in self.commentsList.data {
                                if(cur.comment_id == self.comment.comment_id) {
                                    self.commentsList.data.remove(at: cpt)
                                }
                                cpt += 1
                            }
                        }
                    }){
                        Image("cancel").resizable().frame(width: 15, height: 15)
                    }.buttonStyle(PlainButtonStyle())                }
                //Text(comment.category_description).background(Color.red).cornerRadius(10.0)
            }.padding(10)
            HStack {
                Spacer()
                Circle().fill(Color(self.hexStringToUIColor(hex: comment.color))).frame(width: 25,height: 25)
                
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 10))
            }.background(config.postbarColor())
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
                    
                }.buttonStyle(PlainButtonStyle())
            }.padding([.vertical], 6).padding([.horizontal], 15)
        }.background(config.postColor()).cornerRadius(15.0)/*.onAppear() {
            if(self.rateCommentDAL.hasRated(user: self.user, comment: self.comment) == 1) {
                self.already.liked = true
            } else if (self.rateCommentDAL.hasRated(user: self.user, comment: self.comment) == 0) {
                self.already.disliked = true
            }
            
            if(self.reportCommentDAL.hasReported(user: self.user, comment: self.comment)) {
                self.already.reported = true
            }
        }*/
    }
}
