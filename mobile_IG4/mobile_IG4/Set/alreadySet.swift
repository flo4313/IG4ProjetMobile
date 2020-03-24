//
//  alreadySet.swift
//  mobile_IG4
//
//  Created by user165108 on 24/03/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import UIKit

class AlreadySet : ObservableObject {
    @Published var data: Array<Already>{
        willSet{
            objectWillChange.send()
        }
    }
    
    init() {
        data = Array()
    }
}
