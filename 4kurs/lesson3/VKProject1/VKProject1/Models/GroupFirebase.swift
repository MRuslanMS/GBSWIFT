//
//  GroupFirebase.swift
//  VKProject1
//
//  Created by xc553a8 on 24.10.2021.
//

import Foundation
import FirebaseDatabase




final class GroupFirebase {
    let groupID: Int
    let nameGroup: String

    var ref: DatabaseReference?

    init(groupID: Int, nameGroup: String) {
        self.groupID = groupID
        self.nameGroup = nameGroup
    }

    // дополнительный опциональный инит
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: Any],
            let groupID = value["groupID"] as? Int,
            let nameGroup = value["nameGroup"] as? String
        else { return nil }

        self.groupID = groupID
        self.nameGroup = nameGroup

        self.ref = snapshot.ref // ссылка на объект
    }

    func toDictionary() -> [String: Any] {
        return [String(groupID): nameGroup]
    }

}

