//
//  File.swift
//  hw17NatalliaDrozd
//
//  Created by Natalia Drozd on 1.06.22.
//

import Foundation
import UIKit

enum ContentType: Int {
    case folder = 0
    case image
    
    var description: String {
        switch self {
        case.folder:
            return "Folders"
        case.image:
            return "Image"
        }
    }
}

enum ModeType {
    case navigation
   case selection
    
}

