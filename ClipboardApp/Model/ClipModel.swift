//
//  DataModel.swift
//  ClipboardApp
//
//  Created by Seok on 14/03/2020.
//  Copyright © 2020 swift. All rights reserved.
//

import Foundation
import RealmSwift

//enum ColorTag : Int{
//    case non = -1, red = 0, yellow, green, blue, purple
//}

//class ClipList: Object {
//    let clips = List<ClipModel>()
//}
//
//class TrashList: Object {
//    let trashs = List<ClipModel>()
//}

class ClipModel: Object {
    
    @objc dynamic var isDeleted: Bool = false
    @objc dynamic var modiDate: Date = Date()
    @objc dynamic var copiedText: String = ""
    @objc dynamic var color: Int = -1
    
//    @objc dynamic var _color: Int = -1
//    var color: ColorTag {
//        get {
//            return ColorTag(rawValue: _color)!
//        }
//        set {
//            _color = newValue.rawValue
//        }
//    }
}
