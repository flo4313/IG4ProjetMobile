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
    @ObservedObject var postsObserved : PostSet
    

    var body: some View {
       
            return
            List {
                ForEach(self.postsObserved.data) {
                    post in
                    HStack{
                        
                       NavigationLink(destination : postDetailledView(postEl: post)){
                        
                            postView(post: post)
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
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, posts: postsObserved)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
            let control = UIScrollView()
            control.refreshControl = UIRefreshControl()
            control.refreshControl?.addTarget(context.coordinator, action:
                #selector(Coordinator.handleRefreshControl),
                                              for: .valueChanged)
        let childView = UIHostingController(rootView: postsListView(postsObserved: postsObserved))
            childView.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
            
            control.addSubview(childView.view)
            return control
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {}
    
    class Coordinator: NSObject {
        var control: CustomScrollView
        var posts : PostSet
        init(_ control: CustomScrollView, posts: PostSet) {
            self.control = control
            self.posts = posts
        }
        @objc func handleRefreshControl(sender: UIRefreshControl) {
                sender.endRefreshing()
                self.posts.data.removeAll()
                self.posts.setData()
                
        }
    }
}


