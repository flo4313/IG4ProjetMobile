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
    @EnvironmentObject var user : User
    
    func login(){
        userDAL.login(username: self.username, password: self.password,userP: self.user)
    }
    
    var body: some View {
        VStack {
            WelcomeText()
            TextField("Username" , text: $username)
            .padding()
            .background(lightGreyColor)
                .cornerRadius(5.0)
                .padding(.bottom,20)
            SecureField("Password" , text: $password)
            .padding()
            .background(lightGreyColor)
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

struct WelcomeText : View {
    var body : some View {
        return Text("Welcome !")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom,20)
    }

}


