//
//  registerView.swift
//  mobile_IG4
//
//  Created by etud on 06/03/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import SwiftUI
import CommonCrypto
struct registerView: View {
    @Environment(\.presentationMode) var presentationMode
    private var userDAL : UserDAL = UserDAL()
    @State private var username : String = ""
    @State private var password : String = ""
    @State private var passwordC : String = ""
    @State private var firstname : String = ""
    @State private var lastname : String = ""
    @State private var mail : String = ""
    @State private var birthday : Date = Date()
    @State private var sexe : Bool = false
    @State private var value : CGFloat = 0
    
    
    
    
    func register(){
        if(userDAL.register(firstname: self.firstname, lastname: self.lastname, username: self.username, sexe: self.sexe, birthday: self.birthday, password: self.password, mail: self.mail))
        {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    
    var body: some View {
        return GeometryReader{ geometry in
            ZStack(alignment:.bottomTrailing){
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
                        Text("Birthday")
                        DatePicker(selection : self.$birthday,in: ...Date(), displayedComponents: .date){
                            Text("Select a date")
                        }
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
}

struct registerView_Previews: PreviewProvider {
    static var previews: some View {
        registerView()
    }
}
