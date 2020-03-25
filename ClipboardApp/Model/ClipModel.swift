//
//  DataModel.swift
//  ClipboardApp
//
//  Created by Seok on 14/03/2020.
//  Copyright © 2020 swift. All rights reserved.
//

import Foundation
import RealmSwift

class ClipModel: Object {
    
    @objc dynamic var isDeleted: Bool = false
    @objc dynamic var copiedText: String = ""
}
