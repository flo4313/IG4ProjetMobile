//
//  accountView.swift
//  mobile_IG4
//
//  Created by Thomas Faure on 29/02/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import SwiftUI


struct accountView: View {
    var user : User
    var myUser : UserModel
    var userDal = UserDAL()
    @State private var username : String = ""
    @State private var firstname : String = ""
    @State private var lastname : String = ""
    @State private var mail : String = ""
    
    
    init(user : User) {
        self.user = user
        self.myUser = user.user!
        if let myUser = user.user {
            _username = State(initialValue: myUser.username)
            _firstname = State(initialValue: myUser.firstname)
            _lastname = State(initialValue: myUser.lastname)
            _mail = State(initialValue: myUser.mail)
        }
    }
    
    func logOff(){
        let urlf = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("login.txt")
        try? FileManager.default.removeItem(at: urlf)
        
        self.user.isLogged = false
    }
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Firstname")
                    Spacer()
                }
                TextField("Firstname" , text: self.$firstname)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(5.0)
                    .padding(.bottom,20)
                
                HStack {
                    Text("Lastname")
                    Spacer()
                }
                TextField("Lastname" , text: self.$lastname)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(5.0)
                    .padding(.bottom,20)
                HStack {
                    Text("Username")
                    Spacer()
                }
                TextField("Username" , text: self.$username)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(5.0)
                    .padding(.bottom,20)
                HStack {
                    Text("Mail")
                    Spacer()
                }
                TextField("Mail" , text: self.$mail)
                .padding()
                .background(Color.gray)
                .cornerRadius(5.0)
                .padding(.bottom,20)
            }.padding()
            HStack {
                Button(action: {self.userDal.modifyUser(id: self.myUser.user_id, username: self.username, firstname: self.firstname, lastname: self.lastname, admin: self.myUser.admin, sexe: self.myUser.sexe, birthday: self.myUser.birthday, mail: self.mail)}) {
                    Text("Modify")
                        .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 140, height: 40)
                            .background(Color.green)
                            .cornerRadius(15.0)
                            .padding(.bottom,10)
                        .shadow(color: Color.black.opacity(0.3),
                        radius: 3,
                        x: 3,
                        y: 3)
                    .foregroundColor(.white)
                }
                Spacer()
                Button(action: {self.logOff()}) {
                    Text("LogOff")
                        .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 140, height: 40)
                            .background(Color.red)
                            .cornerRadius(15.0)
                            .padding(.bottom,10)
                        .shadow(color: Color.black.opacity(0.3),
                        radius: 3,
                        x: 3,
                        y: 3)
                    .foregroundColor(.white)
                }
            }.padding()
            Spacer()
        }.navigationBarTitle("My Profile")
    }
}

struct accountView_Previews: PreviewProvider {
    static var previews: some View {
        accountView(user : User())
    }
}
