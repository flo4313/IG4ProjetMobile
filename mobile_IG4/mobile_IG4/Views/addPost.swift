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
    @EnvironmentObject var userE : User
    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    init(postsObserved : PostSet){
        self.postsObserved = postsObserved
    }
    @State private var image: Image?
    @State private var ext : String = ""
    @State private var showingImage = false
    @State private var inputImage: UIImage?
    @State private var selectedCategory : Int = 1
    var postsObserved : PostSet
    @State var title: String = ""
    @State var description: String = ""
    private var postDAL : PostDAL = PostDAL()
    
    
    
    func addPost(){
        if(postDAL.addPost(title: self.title, description: self.description, category: 1,image: inputImage,userE: userE, ext: self.ext)){
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else{
            return
        }
        image = Image(uiImage: inputImage)
    }
    
    var body: some View {
        ScrollView {
            VStack{
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
            
            
                ZStack{
                    Rectangle().fill(Color.secondary)
                    if image != nil{
                        image?.resizable().scaledToFit()
                    }
                    else{
                        Text("Tap to select a picture").foregroundColor(.white).font(.headline)
                    }
                }.onTapGesture {
                    self.showingImage = true
            }
            
                Picker(selection: self.$selectedCategory, label: Text("Categegory")) {
                Text("1").tag(1)
                /*@START_MENU_TOKEN@*/Text("2").tag(2)/*@END_MENU_TOKEN@*/
                }
            
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
            .sheet(isPresented: $showingImage, onDismiss: loadImage){
                MyImagePicker(image: self.$inputImage, ext: self.$ext)
        }
        }
    }
}




