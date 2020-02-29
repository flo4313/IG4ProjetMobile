//
//  ContentView.swift
//  mobile_IG4
//
//  Created by user165108 on 25/02/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import SwiftUI



struct ContentView: View {
    
    @EnvironmentObject var user: User
    @ObservedObject var postsObserved : PostSet
    var posts : PostSet
    init(){
        self.posts = PostSet(search: true)
        self.postsObserved = PostSet(search: false)
        
        
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.logged {
            self.menu1 = "mon compte"
        }else{
            self.menu1 = "connexion"
        }
        for post in posts.data{
            self.postsObserved.add(post:post)
        }
    }
    
    var appDelegate : AppDelegate
    var menu1 : String
    let blue = Color(red: 57.0/255.0, green: 153.0/255.0, blue: 187.0/255.0, opacity: 1.0)
    var body: some View {
        
       
        return
             NavigationView {
                VStack{
                    VStack{
                        searchBarView(posts : posts,postsObserved: postsObserved)
                    }
                    Spacer()
                    VStack{
                        List {
                            ForEach(postsObserved.data) {
                                post in
                                NavigationLink(destination : postDetailledView(postElt: post)){
                                    postView(post: post)
                                }
                                
                                
                        
                            }
                        }
                        .padding(.bottom, 20.0)
                        Spacer()
                        HStack{
                            Spacer()
                            NavigationLink(destination: addPostView(postsObserved: self.postsObserved) ) {
                                                              Text("+")
                                                              .font(.headline)
                                                              .foregroundColor(.white)
                                                                .padding()
                                                              
                                                              .background(blue)
                                                              .cornerRadius(5.0)
                                                               
                                                           
                            }
                            
                            Spacer()
                        }
                        
                    }
                    Spacer()
                    HStack{
                        if(self.user.isLogged == true){
                            NavigationLink(destination: loginView()) {
                                Text("Account")
                            }.font(.headline)
                            .foregroundColor(.white)
                            
                            
                            .background(blue)
                            .cornerRadius(15.0)
                        }else{
                            NavigationLink(destination: loginView()) {
                                Text("Login")
                            }
                        }
                        
                        Spacer()
                        Text(verbatim: "News")
                        Spacer()
                        Text(verbatim: "SOS")
                       
                        }.padding().background(blue)
                }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @EnvironmentObject var user: User
    @ObservedObject var postsObserved : PostSet
    var posts : PostSet
    init(){
        self.posts = PostSet(search: true)
        self.postsObserved = PostSet(search: false)
        
        
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.logged {
            self.menu1 = "mon compte"
        }else{
            self.menu1 = "connexion"
        }
        for post in posts.data{
            self.postsObserved.add(post:post)
        }
    }
    
    var appDelegate : AppDelegate
    var menu1 : String
    let blue = Color(red: 57.0/255.0, green: 153.0/255.0, blue: 187.0/255.0, opacity: 1.0)

    static var previews: some View {
        ContentView()
    }
}
