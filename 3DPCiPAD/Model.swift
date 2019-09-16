//
//  Model.swift
//  PushingBoundaries
//
//  Created by Laurent B on 18/07/2019.
//  Copyright © 2019 Laurent B. All rights reserved.
//

import Foundation

class Models: Codable {
    let models: [Model]
}

class Model: Codable {
    
    var title = ""
    var subtitle = ""
    var image = ""
    var contentText = ""
}
