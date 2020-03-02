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
    @ObservedObject var posts : PostSet
    init(){
        self.posts = PostSet(search: true)
        self.postsObserved = PostSet(search: true)
        
        
       for post in posts.data{
            self.postsObserved.add(post:post)
        }
    }
    
 
  
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
                        HStack{
                            Spacer()
                            Button(action: {
                                self.postsObserved.data.removeAll()
                                self.posts.setData()
                                for post in self.posts.data{
                                    self.postsObserved.add(post:post)
                                }
                                
                            }) {
                                      Text("refresh")
                                      .font(.headline)
                                      .foregroundColor(.white)
                            .padding()
                                      
                                      .background(blue)
                                      .cornerRadius(5.0)
                        }
                            Spacer()
                        }
                        List {
                            ForEach(self.postsObserved.data) {
                                post in
                                HStack{
                                    
                                   NavigationLink(destination : postDetailledView(postEl: post)){
                                    
                                        postView(post: post)
                                    }
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
                        Spacer()
                        if(self.user.isLogged == true){
                            NavigationLink(destination: accountView()) {
                                Text("Account")
                            }.font(.headline)
                            .foregroundColor(.white)
                            
                            
                            .background(blue)
                            .cornerRadius(15.0)
                        }else{
                            NavigationLink(destination: loginView()) {
                                Text("Login")
                            }.font(.headline)
                            .foregroundColor(.white)
                            
                            
                            .background(blue)
                            .cornerRadius(15.0)
                            .frame(alignment : .center)
                        }
                        
                        Spacer()
                        NavigationLink(destination: loginView()) {
                            Text("News")
                        }.font(.headline)
                        .foregroundColor(.white)
                        
                        
                        .background(blue)
                        .cornerRadius(15.0)
                        .frame(alignment : .center)
                        Spacer()
                        NavigationLink(destination: loginView()) {
                            Text("Sos")
                        }.font(.headline)
                        .foregroundColor(.white)
                        
                        
                        .background(blue)
                        .cornerRadius(15.0)
                        .frame(alignment : .center)
                        Spacer()
                    }.padding().background(blue)
                }
            
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    @EnvironmentObject var user: User
    @ObservedObject var postsObserved : PostSet
    @ObservedObject var posts : PostSet
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
