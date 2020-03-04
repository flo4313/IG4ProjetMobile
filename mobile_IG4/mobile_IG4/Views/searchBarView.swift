//
//  searchBarView.swift
//  mobile_IG4
//
//  Created by user165108 on 29/02/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import SwiftUI

struct searchBarView : View {
    let blue = Color(red: 57.0/255.0, green: 153.0/255.0, blue: 187.0/255.0, opacity: 1.0)
    var filtreun : Bool = false
    var posts : PostSet
    @State var orderByDateAcd : Int = 0
    @State var orderByComment : Int = 0
    @State var orderByPopulaire : Int = 0
    @State var recent : String = "Recent"
    @State var comment : String = "Comment"
    @State var populaire : String = "Populaire"
    var postsObserved : PostSet
    @State private var name: String = ""

    
    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    func setSearchBarResult(){
        if name.count != 0 {
            self.postsObserved.data = self.posts.data.filter{$0.title.lowercased().contains(name.lowercased())}
        } else {
            self.postsObserved.data = self.posts.data
        }
        self.filtre()
    }
    func filtre(){
        self.filterByPopulaire()
        self.filterByDate()
        self.filterByComment()
    }
    
    func filterByDate(){
        self.orderByComment = 0
        self.comment = "Comment"
        self.orderByPopulaire = 0
        self.populaire = "Populaire"
        if orderByDateAcd == 0 {
            self.postsObserved.data = self.postsObserved.data.sorted {$0.post_id < $1.post_id}
            self.orderByDateAcd = 1
            self.recent = "Recent ▽"
        } else if orderByDateAcd == 1{
            self.postsObserved.data = self.postsObserved.data.sorted {$0.post_id > $1.post_id}
            self.orderByDateAcd = 2
            self.recent = "Recent △"
        }
        else{
            self.orderByDateAcd = 0
            self.recent = "Recent"
        }
        
    }
    
    func filterByComment(){
        self.orderByDateAcd = 0
        self.recent = "Recent"
        self.orderByPopulaire = 0
        self.populaire = "Populaire"
        if orderByComment == 0 {
            self.postsObserved.data = self.postsObserved.data.sorted {$0.comment > $1.comment}
            self.orderByComment = 1
            self.comment = "Comment ▽"
            
        } else if orderByComment == 1{
            self.postsObserved.data = self.postsObserved.data.sorted {$0.comment < $1.comment}
            self.orderByComment = 2
            self.comment = "Comment △"
        }
        else{
            self.orderByComment = 0
            self.comment = "Comment"
        }
        
    }

    func filterByPopulaire(){
        self.orderByDateAcd = 0
        self.recent = "Recent"
        self.orderByComment = 0
        self.comment = "Comment"
        if  orderByPopulaire == 0 {
            self.postsObserved.data = self.postsObserved.data.sorted {$0.like > $1.like}
            self.orderByPopulaire = 1
            self.populaire = "Populaire ▽"
            
        } else if orderByPopulaire == 1{
            self.postsObserved.data = self.postsObserved.data.sorted {$0.like < $1.like}
            self.orderByPopulaire = 2
            self.populaire = "Populaire △"
        }
        else{
            self.orderByPopulaire = 0
            self.populaire = "Populaire"
        }
        
    }

    var body: some View {
        let binding = Binding<String>(get: {
            self.name
        }, set: {
            self.name = $0
            self.setSearchBarResult()
        })
        return
            VStack{
                HStack(alignment:.top){
                    TextField("Search", text: binding).background(lightGreyColor).padding()
                    
                }
                
                HStack{
                    Spacer()
                    Button(action: {self.filterByDate()}) {
                        Text("\(self.recent)")
                            .font(.headline)
                            .foregroundColor(.white)
                            .background(blue)
                            .cornerRadius(15.0)
                        
                    }
                    Spacer()
                    
                    Button(action: {self.filterByComment()}) {
                        Text("\(self.comment)")
                            .font(.headline)
                            .foregroundColor(.white)
                            .background(blue)
                            .cornerRadius(15.0)
                    }
                    
                    Spacer()
                    Button(action: {self.filterByPopulaire()}) {
                        Text("\(self.populaire)")
                            .font(.headline)
                            .foregroundColor(.white)
                            .background(blue)
                            .cornerRadius(15.0)
                        
                    }
                    Spacer()
                }.padding().background(blue)
        }
    }
}


struct searchBarView_Previews: PreviewProvider {
    
    static var previews: some View {
        searchBarView(posts : PostSet(search: true),postsObserved: PostSet(search: false))
    }
}
