//
//  loginView.swift
//  mobile_IG4
//
//  Created by user165108 on 27/02/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import SwiftUI
import CommonCrypto

struct loginView: View {
    @Environment(\.presentationMode) var presentationMode
    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    @State var username: String = ""
    @State var password: String = ""
    @EnvironmentObject var user : User
    
    func sha256(str: String) -> String {
     
        if let strData = str.data(using: String.Encoding.utf8) {
            /// #define CC_SHA256_DIGEST_LENGTH     32
            /// Creates an array of unsigned 8 bit integers that contains 32 zeros
            var digest = [UInt8](repeating: 0, count:Int(CC_SHA256_DIGEST_LENGTH))
     
            /// CC_SHA256 performs digest calculation and places the result in the caller-supplied buffer for digest (md)
            /// Takes the strData referenced value (const unsigned char *d) and hashes it into a reference to the digest parameter.
            strData.withUnsafeBytes {
                // CommonCrypto
                // extern unsigned char *CC_SHA256(const void *data, CC_LONG len, unsigned char *md)  -|
                // OpenSSL                                                                             |
                // unsigned char *SHA256(const unsigned char *d, size_t n, unsigned char *md)        <-|
                CC_SHA256($0.baseAddress, UInt32(strData.count), &digest)
            }
     
            var sha256String = ""
            /// Unpack each byte in the digest array and add them to the sha256String
            for byte in digest {
                sha256String += String(format:"%02x", UInt8(byte))
            }
     
            if sha256String.uppercased() == "E8721A6EBEA3B23768D943D075035C7819662B581E487456FDB1A7129C769188" {
                print("Matching sha256 hash: E8721A6EBEA3B23768D943D075035C7819662B581E487456FDB1A7129C769188")
            } else {
                print("sha256 hash does not match: \(sha256String)")
            }
            return sha256String
        }
        return ""
    }
    
    func login(username: String,password: String){
        
        let passwordCrypted = sha256(str: password)
        print(username+" "+password)
        let person = Person(username: username, password: passwordCrypted)
        guard let encoded = try? JSONEncoder().encode(person) else {
            print("Failed to encode order")
            return
        }
        let group = DispatchGroup()
        group.enter()
      
        var user_id = 0
        var token = ""
        var isLogged = false
        if let url = URL(string: "http://51.255.175.118:2000/user/login") {
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Application")
            request.httpMethod = "POST"
            request.httpBody = encoded
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                       
                        let res = try? JSONDecoder().decode(Login.self, from: data)
                        if let res2 = res{
                            print(res2.token)
                            token = res2.token
                            user_id = res2.id
                            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                            let urlf = paths[0].appendingPathComponent("login.txt")
                            var str = person.username+"\n"+passwordCrypted
                            try? str.write(to: urlf, atomically: true, encoding: .utf8)
                            isLogged = true
                            
                        }else{
                            print("pas connecté")
                        }
                        group.leave()
             
                }
            }.resume()
        }
        
        group.wait()
            var user : UserModel? = nil
            if(isLogged){
                group.enter()
                if let url = URL(string: "http://51.255.175.118:2000/user/"+String(user_id)) {
                    var request = URLRequest(url: url)
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue("application/json", forHTTPHeaderField: "Application")
                    request.setValue("Bearer "+token,forHTTPHeaderField: "Authorization")
                    request.httpMethod = "GET"
        
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        if let data = data {
                                print("on a un utilisateur")
                                let res = try? JSONDecoder().decode([UserModel].self, from: data)
                               
                                if let res = res{
                                     user = res[0]
                                }
                                group.leave()
                        }
                    }.resume()
                }
                group.wait()
                self.presentationMode.wrappedValue.dismiss()
                self.user.isLogged = true
                self.user.user = user
                self.user.token = token
                print(self.user.user!.username)
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


