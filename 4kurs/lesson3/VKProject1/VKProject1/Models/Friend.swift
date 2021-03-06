//
//  Friend.swift
//  VKProject1
//
//  Created by xc553a8 on 15.10.2021.
//

import UIKit
import RealmSwift

class Friend: Object {
    @objc dynamic var userName: String = ""
    @objc dynamic var userAvatar: String  = ""
    @objc dynamic var ownerID: String  = ""
    
    init(userName:String, userAvatar:String, ownerID:String) {
        self.userName = userName
        self.userAvatar = userAvatar
        self.ownerID = ownerID
    }
    
    // этот инит обязателен для Object
    required override init() {
        super.init()
    }
}
