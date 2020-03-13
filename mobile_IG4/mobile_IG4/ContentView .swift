//
//  ContentView.swift
//  mobile_IG4
//
//  Created by user165108 on 25/02/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    private var config = Config()
    @EnvironmentObject var userE: User
    @ObservedObject var postsObserved : PostSet
    @ObservedObject var posts : PostSet
    init(){
        self.posts = PostSet(search: true)
        self.postsObserved = PostSet(search: true)
        
    }
    
    
    var body: some View {
        
        
        return
            NavigationView {
                VStack{
                    VStack{
                        searchBarView(posts : posts,postsObserved: postsObserved)
                    }.navigationBarItems(leading:
                    HStack {
                            Image("logo")
                                .font(.largeTitle)
                    })
                        .navigationBarTitle(Text("Say No To Sexism"))
                    
                    Spacer()
                    ZStack{
                        if(self.postsObserved.data.count != 0){
                            GeometryReader{
                                geometry in
                                CustomScrollView(width: geometry.size.width, height: geometry.size.height, postsObserved: self.postsObserved)
                            }
                        }
                        else{
                            Text("No post")
                        }
                        
                        VStack() {
                            Spacer()
                            HStack{
                                Spacer()
                                NavigationLink(destination: addPostView(postsObserved: self.postsObserved) ) {
                                    Image("write")
                                        .resizable()
                                        .padding()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.white)
                                        .background(Color.yellow)
                                        .cornerRadius(38.5)
                                        .shadow(color: Color.black.opacity(0.3),
                                                radius: 3,
                                                x: 3,
                                                y: 3)
                                }
                            }.padding()
                        }.padding()
                        
                    }
                    Spacer()
                    
                    HStack{
                        Spacer()
                        if(self.userE.isLogged == true){
                            NavigationLink(destination: accountView()) {
                                Text("Account")
                            }.font(.headline)
                                .foregroundColor(.white)
                                
                                
                                .background(config.postbarColor())
                                .cornerRadius(15.0)
                        }else{
                            NavigationLink(destination: loginView()) {
                                Text("Login")
                            }.font(.headline)
                                .foregroundColor(.white)
                                
                                
                                .background(config.postbarColor())
                                .cornerRadius(15.0)
                                .frame(alignment : .center)
                        }
                        
                        Spacer()
                        NavigationLink(destination: loginView()) {
                            Text("News")
                        }.font(.headline)
                            .foregroundColor(.white)
                            
                            
                            .background(config.postbarColor())
                            .cornerRadius(15.0)
                            .frame(alignment : .center)
                        Spacer()
                        NavigationLink(destination: SOSview()) {
                            Text("Sos").foregroundColor(Color.red)
                        }.font(.headline)
                            .foregroundColor(.white)
                            .background(config.postbarColor())
                            .cornerRadius(15.0)
                            .frame(alignment : .center)
                        Spacer()
                    }.padding().background(config.postbarColor())
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
