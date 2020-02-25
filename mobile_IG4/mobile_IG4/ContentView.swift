//
//  ContentView.swift
//  mobile_IG4
//
//  Created by user165108 on 25/02/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var posts = PostSet()
    var body: some View {
        ZStack{
            Color.blue.edgesIgnoringSafeArea(.all)
            VStack{
                VStack{
                    List {
                        ForEach(posts.data) {
                            post in
                            postView(post: post)
                        }
                    }
                    .padding(.bottom, 20.0)
                }
                HStack{
                    Spacer()
                    Text(verbatim: "Mon compte")
                    Spacer()
                    Text(verbatim: "News")
                    Spacer()
                    Text(verbatim: "SOS")
                    Spacer()
                    }.padding().background(Color.green)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
