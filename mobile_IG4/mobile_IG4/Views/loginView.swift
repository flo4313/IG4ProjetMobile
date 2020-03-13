//
//  loginView.swift
//  mobile_IG4
//
//  Created by user165108 on 27/02/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import SwiftUI


struct loginView: View {
    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    @State var username: String = ""
    @State var password: String = ""
    private var userDAL : UserDAL = UserDAL()
    @EnvironmentObject var userE : User
    @State private var value : CGFloat = 0
    
    func login(){
        userDAL.login(username: self.username, password: self.password, userE: userE)
    }
    
    var body: some View {GeometryReader{ geometry in
        ZStack(alignment:.bottomTrailing){
            ScrollView {
                VStack {
                    WelcomeText()
                    TextField("Username" , text: self.$username)
                        .padding()
                        .background(self.lightGreyColor)
                        .cornerRadius(5.0)
                        .padding(.bottom,20)
                    SecureField("Password" , text: self.$password)
                        .padding()
                        .background(self.lightGreyColor)
                        .cornerRadius(5.0)
                        .padding(.bottom,20)
                    
                    
                    
                    Button(action: {self.login()}) {
                        Text("LOGIN")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(Color.green)
                            .cornerRadius(15.0)
                    }.padding(.bottom, 10)
                    NavigationLink(destination: registerView()) {
                        Text("Register")
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
        .padding(.top, self.value - 5)
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
}

struct WelcomeText : View {
    var body : some View {
        return Text("Welcome !")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom,20)
    }
    
}


