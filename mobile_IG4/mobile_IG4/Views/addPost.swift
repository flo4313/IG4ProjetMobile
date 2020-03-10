//
//  loginView.swift
//  mobile_IG4
//
//  Created by user165108 on 27/02/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import SwiftUI



struct addPostView: View {
    @Environment(\.presentationMode) var presentationMode
    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    init(postsObserved : PostSet){
        self.postsObserved = postsObserved
    }
    var postsObserved : PostSet
    @State var title: String = ""
    @State var description: String = ""
    private var postDAL : PostDAL = PostDAL()
    
    
    
    func addPost(){
        if(postDAL.addPost(title: self.title, description: self.description, userId: 0)){
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    var body: some View {
        VStack {
            Text("Add a new post !")
            TextField("Title" , text: $title)
            .padding()
            .background(lightGreyColor)
                .cornerRadius(5.0)
                .padding(.bottom,20)
            TextField("Description" , text: $description)
            .padding()
            .background(lightGreyColor)
                .cornerRadius(5.0)
                .padding(.bottom,20)
            
            
            
            Button(action: {self.addPost()}) {
               Text("Add")
               .font(.headline)
               .foregroundColor(.white)
               .padding()
               .frame(width: 220, height: 60)
               .background(Color.green)
               .cornerRadius(15.0)
            }
        
        }.padding()
    }
}




