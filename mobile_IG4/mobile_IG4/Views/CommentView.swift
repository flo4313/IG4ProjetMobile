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
    
    init(comment : Comment) {
        self.comment = comment
    }
    var body: some View {
        VStack{
           Text(comment.description)
            Text(comment.description)
        }
    }
}
