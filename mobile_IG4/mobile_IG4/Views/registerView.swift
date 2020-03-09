//
//  registerView.swift
//  mobile_IG4
//
//  Created by etud on 06/03/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import SwiftUI

struct registerView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var username : String = ""
    @State private var password : String = ""
    @State private var passwordC : String = ""
    @State private var firstname : String = ""
    @State private var lastname : String = ""
    @State private var mail : String = ""
    @State private var birthday : Date = Date()
    @State private var sexe : Bool = false
    @State private var value : CGFloat = 0
    
    private func keyboardUp(){
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main){
            (noti) in
            let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            let height = value.height
            self.value = height
            
        }
    }
    
    struct Response :Decodable {
        var result: Bool
        var id: Int
    }
    
    func register(){
        var s : String
        if(self.sexe){
            s = "M"
        }
        else {
            s = "F"
        }
        let user = User(user_id: 0, username: self.username, firstname: self.firstname, lastname: self.lastname, mail: self.mail, password: self.password, birthday: self.birthday, sexe: s)
        print(user.sexe)
        guard let encoded = try? JSONEncoder().encode(user) else {
            print("Failed to encode order")
            return
        }
        var isCreate = false
        let group = DispatchGroup()
        group.enter()
        if let url = URL(string: "http://51.255.175.118:2000/user/create") {
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Application")
            request.httpMethod = "POST"
            request.httpBody = encoded
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    let res = try? JSONDecoder().decode(Response.self, from: data)
                    if let res2 = res{
                        if(res2.result == true){
                            isCreate = true
                        }
                    }else{
                        print("error")
                    }
                    group.leave()
                    
                }
            }.resume()
        }
        group.wait()
        if(isCreate == true){
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    
    var body: some View {
        return GeometryReader{ geometry in
            ScrollView {
                VStack{
                    Text("Firstname").navigationBarTitle("Register")
                    TextField("Firstname" , text: self.$firstname)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(5.0)
                        .padding(.bottom,20)
                    Text("Lastname")
                    TextField("Lastname" , text: self.$lastname)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(5.0)
                        .padding(.bottom,20)
                    Text("Username")
                    TextField("Username" , text: self.$username)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(5.0)
                        .padding(.bottom,20)
                }
                VStack{
                    Text("Mail")
                    TextField("Mail" , text: self.$mail)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(5.0)
                        .padding(.bottom,20)
                    
                    Text("Sexe")
                    Toggle(isOn: self.$sexe) {
                        Text(self.sexe ? "Male" : "Female")
                    }
                }
                
                
                Text("Password")
                SecureField("Password" , text: self.$password)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(5.0)
                    .padding(.bottom,20)
                
                Text("Password Confirmation")
                SecureField("Password" , text: self.$passwordC)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(5.0)
                    .padding(.bottom,20)
                
                
                
                
                Button(action:{self.register()}) {
                    Text("REGISTER")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color.green)
                        .cornerRadius(15.0)
                }
            }.padding()
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

struct registerView_Previews: PreviewProvider {
    static var previews: some View {
        registerView()
    }
}
