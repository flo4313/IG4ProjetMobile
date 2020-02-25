//
//  postView.swift
//  mobile_IG4
//
//  Created by user165108 on 25/02/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import SwiftUI

struct postView: View {
    var post: Post
     
    var body: some View {
    
        VStack(alignment: .leading) {
           
                Text(self.post.title)
                        .font(.title)
                        .fontWeight(.light)
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.leading)
                Text(self.post.description)
                .multilineTextAlignment(.leading)
        }
    }
}

struct SwiftUICellView_Previews: PreviewProvider {
    static var previews: some View {
    postView(post: Post(post_id: 1, title: "foo", description: "foofoofoo", post_category: 1, author: 1, url_image: "url", date: "1"))

    }
}
