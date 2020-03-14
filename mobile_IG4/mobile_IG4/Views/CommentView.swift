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
    var comment : Comment
    var config = Config()
    
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
                    Button(action: {print("TODO Like")}) {
                        Image("upArrow").resizable().frame(width: 12, height : 12)
                    }
                    Text("\(comment.like)").font(.system(size: 15))
                    Button(action: {print("TODO Disike")}) {
                        Image("downArrow").resizable().frame(width: 12, height : 12)
                    }
                    Spacer()
                    Button(action: {print("TODO report")}) {
                        Image("warning").resizable().frame(width: 15, height : 15)
                    }
                    
                }.buttonStyle(PlainButtonStyle())
            }.padding([.vertical], 6).padding([.horizontal], 15)
        }.background(config.postColor()).cornerRadius(15.0)
    }
}
