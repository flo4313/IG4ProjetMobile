//
//  categoryPicker.swift
//  mobile_IG4
//
//  Created by Thomas Faure on 20/03/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import SwiftUI

struct categoryPicker: View {

    var postCategory : PostCategorySet
    var catBinding : Binding<Int>
    init(bind: Binding<Int>){
        self.catBinding = bind
        self.postCategory = PostCategorySet()
        self.postCategory.data.append(PostCategory(post_category_id: -1, description: "default", couleur: "#ffffff"))
    }
    
    var body: some View {
        
    
        return
         VStack {
            Text("Choose a category")
           List {
           if(postsObserved.data.count ==  0){
               Text("No post")
           }else{
           ForEach(0...postsObserved.data.count - 1, id: \.self) {
               i in
               HStack{
                   NavigationLink(destination : postDetailledView(postEl: self.postsObserved.data[i], already: self.already[i])){
                       postView(post: self.postsObserved.data[i], already : self.already[i], descriptionBestAnswer: self.descriptionBestAnswer[i],user: self.userE)
                   }
               }
           }
           }
           }.padding(.bottom, 20.0)
            
            
            Picker(selection: catBinding, label: Text("")) {
                ForEach(self.postCategory.data){
                    category in
                    Text(category.description).tag(category.post_category_id)
                }
            
                
            }.labelsHidden()
            Spacer()
                
                
            
                
        
        }
        
        
    }
}

