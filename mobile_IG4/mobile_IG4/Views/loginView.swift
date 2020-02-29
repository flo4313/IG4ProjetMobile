//
//  loginView.swift
//  mobile_IG4
//
//  Created by user165108 on 27/02/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import SwiftUI



struct loginView: View {
    @Environment(\.presentationMode) var presentationMode
    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    @State var username: String = ""
    @State var password: String = ""
    @EnvironmentObject var user : User
    
    func login(username: String,password: String){
        print(username+" "+password)
        let person = Person(username: username, password: password)
        guard let encoded = try? JSONEncoder().encode(person) else {
            print("Failed to encode order")
            return
        }
        let group = DispatchGroup()
        group.enter()
        var isLogged = false
        if let url = URL(string: "http://51.255.175.118:2000/user/login") {
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Application")
            request.httpMethod = "POST"
            request.httpBody = encoded
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                        print("on y est !")
                        let res = try? JSONDecoder().decode(Login.self, from: data)
                        if let res2 = res{
                            print(res2.token)
                            
                            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                            let urlf = paths[0].appendingPathComponent("login.txt")
                            isLogged = true
                            
                        }else{
                            print("pas connecté")
                        }
                        group.leave()
             
                }
            }.resume()
        }
        group.wait()
        if(isLogged) {
            self.user.isLogged = true
        }
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
            
            
            
            Button(action: {self.login(username: self.username,password: self.password)}) {
               Text("LOGIN")
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


