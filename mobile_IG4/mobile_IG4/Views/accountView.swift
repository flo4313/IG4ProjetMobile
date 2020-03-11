//
//  accountView.swift
//  mobile_IG4
//
//  Created by Thomas Faure on 29/02/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import SwiftUI


struct accountView: View {
    @EnvironmentObject var user : User
    func logOff(){
        let urlf = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("login.txt")
        try? FileManager.default.removeItem(at: urlf)
        
        self.user.isLogged = false
    }
    var body: some View {
        Button(action: {self.logOff()}) {
        Text("LogOff")
            .font(.largeTitle)
        .foregroundColor(.white)
        
        
        
        }.background(Color.red)
        .cornerRadius(15.0)
    }
}

struct accountView_Previews: PreviewProvider {
    static var previews: some View {
        accountView()
    }
}
