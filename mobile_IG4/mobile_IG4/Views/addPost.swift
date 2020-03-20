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
        self.postCategory = PostCategorySet()
    }
    var postCategory : PostCategorySet
    @State private var image: Image?
    @State private var ext : String = ""
    @State private var showingImage = false
    @State private var inputImage: UIImage?
    @State private var selectedCategory : Int = 1
    var postsObserved : PostSet
    @State private var value : CGFloat = 0
    @State var title: String = ""
    @State var description: String = ""
    @State var isChecked:Bool = false
    private var postDAL : PostDAL = PostDAL()
    
    
    func toggle(){isChecked = !isChecked}
    func addPost(){
        if(postDAL.addPost(title: self.title, description: self.description, category: self.selectedCategory,image: inputImage,userE: userE, ext: self.ext,location : "",anonymous:self.isChecked)){
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
        switch self.userE.isLogged{
        case true:
            return AnyView(self.vue1)
        case false:
            return AnyView(vue2)
        }
    }
    
    var vue2: some View{
        VStack{
        Text("You need to be logged to add a post").padding(.bottom,10)
        NavigationLink(destination: loginView()) {
            Text("Login")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 220, height: 60)
                .background(Color.green)
                .cornerRadius(15.0)
                .padding(.bottom,10)
        }
        NavigationLink(destination: registerView()) {
            Text("Register")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 220, height: 60)
                .background(Color.green)
                .cornerRadius(15.0).padding(.bottom,10)
        }
        }
    }
    
    var vue1: some View{
        GeometryReader{ geometry in
            ZStack(alignment:.bottomTrailing){
                ScrollView {
                    VStack{
                        Text("Add a new post !")
                        TextField("Title" , text: self.$title)
                            .padding()
                            .background(self.lightGreyColor)
                            .cornerRadius(5.0)
                            .padding(.bottom,20)
                        TextField("Description" , text: self.$description)
                            .padding()
                            .background(self.lightGreyColor)
                            .cornerRadius(5.0)
                            .padding(.bottom,20)
                        Button(action: self.toggle){
                            Image(self.isChecked ? "checked" : "notChecked").resizable().frame(width:25,height: 25)
                            Text("anonymous ?")
                        }
                        
                        
                        ZStack{
                            Rectangle().fill(Color.secondary)
                            if self.image != nil{
                                self.image?.resizable().scaledToFit()
                            }
                            else{
                                Text("Tap to select a picture").foregroundColor(.white).font(.headline).padding(.top,20).padding(.bottom,20)
                            }
                        }.onTapGesture {
                            self.showingImage = true
                        }
                        
                        Picker(selection: self.$selectedCategory, label: Text("Categegory")) {
                            ForEach(self.postCategory.data){
                                category in
                                Text(category.description).tag(category.post_category_id)
                            }
                            
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
                        .sheet(isPresented: self.$showingImage, onDismiss: self.loadImage){
                            MyImagePicker(image: self.$inputImage, ext: self.$ext)
                    }
                }
                
            }}.padding(.top, self.value - 5)
            .offset(y: -self.value)
            .animation(.spring())
            .onAppear{
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main){
                    (noti) in
                    let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                    let height = value.height
                    self.value = height + 5
                    
                }
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main){
                    (noti) in
                    self.value = 0
                }
        }
    }
    
}




