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
        
        VStack{
            List {
                ForEach(posts.data) {
                    post in
                    postView(post: post)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
