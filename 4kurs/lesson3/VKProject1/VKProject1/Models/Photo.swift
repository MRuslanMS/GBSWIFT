//
//  Photo.swift
//  VKProject1
//
//  Created by xc553a8 on 2021-08-21.
//

import UIKit
import RealmSwift

class Photo: Object {
    @objc dynamic var photo: String = ""
    @objc dynamic var ownerID: String  = ""

    init(photo: String, ownerID: String) {
        self.photo = photo
        self.ownerID = ownerID
        
    }
    

    required override init() {
        super.init()
    }
}
