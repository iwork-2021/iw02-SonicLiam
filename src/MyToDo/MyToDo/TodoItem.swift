//
//  TodoItem.swift
//  MyToDo
//
//  Created by Liam on 2021/10/31.
//

import UIKit

class TodoItem: NSObject, Encodable, Decodable {

    var title:String
    var isChecked:Bool
    
    init(title:String, isChecked:Bool){
        self.title = title
        self.isChecked = isChecked
        
    }
}
