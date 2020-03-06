//
//  registerView.swift
//  mobile_IG4
//
//  Created by etud on 06/03/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import SwiftUI

struct registerView: View {
    @State private var username : String = ""
    @State private var password : String = ""
    @State private var birthday : Date = Date()
    
    var body: some View {
        VStack {
            Text("Register")
            VStack{
                Text("Firstname")
                TextField("Firstname" , text: $username)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(5.0)
                    .padding(.bottom,20)
                Text("LastName")
                TextField("Lastname" , text: $username)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(5.0)
                    .padding(.bottom,20)

            }
            VStack{
                Text("Mail")
                TextField("Mail" , text: $username)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(5.0)
                    .padding(.bottom,20)

                Text("Sexe")
                TextField("Username" , text: $username)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(5.0)
                    .padding(.bottom,20)
            }
            

            Text("Password")
            SecureField("Password" , text: $password)
                .padding()
                .background(Color.gray)
                .cornerRadius(5.0)
                .padding(.bottom,20)

            Text("Password Confirmation")
            SecureField("Password" , text: $password)
                .padding()
                .background(Color.gray)
                .cornerRadius(5.0)
                .padding(.bottom,20)

            
            
            Button(action:{}) {
                Text("REGISTER")
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

struct registerView_Previews: PreviewProvider {
    static var previews: some View {
        registerView()
    }
}
