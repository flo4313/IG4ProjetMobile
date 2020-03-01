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
    @State var orderByDateAcd : Bool = true
    var postsObserved : PostSet
    @State private var name: String = ""
    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    func setSearchBarResult(){
        self.orderByDateAcd = true
        if name.count != 0 {
            self.postsObserved.data = self.posts.data.filter{$0.title.lowercased().contains(name.lowercased())}
        } else {
            self.postsObserved.data = self.posts.data
        }
    }
    func test(){
    print("oui")
    }
    
     func filterByDate(){
        if orderByDateAcd == true {
            self.postsObserved.data = self.postsObserved.data.sorted {$0.id < $1.id}
            
        } else {
            self.postsObserved.data = self.postsObserved.data.sorted {$0.id > $1.id}
        }
        self.orderByDateAcd = !self.orderByDateAcd
        
    }

    var body: some View {
        return
            VStack{
            HStack(alignment:.top){
                TextField("Enter a post name", text: $name).background(lightGreyColor).padding()
                Button(action: {self.setSearchBarResult()}) {
                              Text("ok")
                              .font(.headline)
                              .foregroundColor(.white)
                    .padding()
                              
                              .background(blue)
                              .cornerRadius(5.0)
                }
               
                
            }
         
            HStack{
            Spacer()
        
                if(self.orderByDateAcd){
                Button(action: {self.filterByDate()}) {
               Text("On")
               .font(.headline)
               .foregroundColor(.white)
               .background(blue)
               .cornerRadius(15.0)
                
            }
                }else{
                    Button(action: {self.filterByDate()}) {
                                  Text("Off")
                                  .font(.headline)
                                  .foregroundColor(.white)
                                  .background(blue)
                                  .cornerRadius(15.0)
                                   
                               }
                }
            Spacer()
            Button(action: {}) {
               Text("filtre2")
               .font(.headline)
               .foregroundColor(.white)
               
               
               .background(blue)
               .cornerRadius(15.0)
                
            }
            Spacer()
            Button(action: {}) {
               Text("filtre3")
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
