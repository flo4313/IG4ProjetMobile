//
//  postsListView.swift
//  mobile_IG4
//
//  Created by user165108 on 03/03/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import Foundation
import SwiftUI



struct postsListView: View {
    var postDAL = PostDAL()
    @EnvironmentObject var userE: User
    @ObservedObject var postsObserved : PostSet
    @ObservedObject var already : AlreadySet
    @ObservedObject var descriptionBestAnswer : StringSet
    
    init(postsObserved: PostSet, already : AlreadySet, descriptionBestAnswer : StringSet) {
        self.postsObserved = postsObserved
        self.already = already
        self.descriptionBestAnswer = descriptionBestAnswer
    }
    
    var body: some View {
    
            return
            List {
                if(postsObserved.data.count ==  0){
                    Text("No post")
                }else{
                ForEach(0...postsObserved.data.count - 1, id: \.self) {
                    i in
                    HStack{
                        NavigationLink(destination : postDetailledView(postEl: self.postsObserved.data[i], already: self.already.data[i])){
                            postView(post: self.postsObserved.data[i], already : self.already.data[i], descriptionBestAnswer: self.descriptionBestAnswer.data[i],user: self.userE)
                        }
                    }
                }
                }
                }.padding(.bottom, 20.0)
            
       
        
    }
    
}

struct CustomScrollView : UIViewRepresentable {

    var width : CGFloat
    var height : CGFloat

    let postsObserved : PostSet
    var already : AlreadySet
    var descriptionBestAnswer : StringSet
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, posts: postsObserved, already : already, descriptionBestAnswer: descriptionBestAnswer)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
            let control = UIScrollView()
            control.refreshControl = UIRefreshControl()
            control.refreshControl?.addTarget(context.coordinator, action:
                #selector(Coordinator.handleRefreshControl),
                                              for: .valueChanged)
        let childView = UIHostingController(rootView: postsListView(postsObserved: postsObserved, already: already, descriptionBestAnswer : descriptionBestAnswer))
            childView.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
            
            control.addSubview(childView.view)
            return control
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {}
    
    class Coordinator: NSObject {
        var control: CustomScrollView
        var posts : PostSet
        var already : AlreadySet
        var descriptionBestAnswer : StringSet
        var postDAL = PostDAL()
        
        init(_ control: CustomScrollView, posts: PostSet, already: AlreadySet, descriptionBestAnswer : StringSet) {
            self.control = control
            self.posts = posts
            self.already = already
            self.descriptionBestAnswer = descriptionBestAnswer
        }
        
        @objc func handleRefreshControl(sender: UIRefreshControl) {
                sender.endRefreshing()
                self.posts.data.removeAll()
                self.posts.setData()
                self.already.data = (0...posts.data.count - 1).map{_ in Already()}
                let bestAnswers = postDAL.getBestAnswers()
                let tmp = posts
                self.descriptionBestAnswer.data = tmp.data.map({(post) -> String in
                    for answer in bestAnswers {
                        if(answer.post == post.post_id && answer.rate > 0) {
                            return answer.description
                        }
                    }
                    return ""
                })
                
        }
    }
}


