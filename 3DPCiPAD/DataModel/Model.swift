//
//  Model.swift
//  PushingBoundaries
//
//  Created by Laurent B on 14/10/2019.
//  Copyright © 2019 Laurent B. All rights reserved.
//

struct Models: Codable {
    var models = [Model]()
}

struct Model: Codable {
    var title: String = ""
    var subtitle: String = ""
    var image: String = ""
    var contentText: String = ""
}

// sorting functions
func < (lhs: Model, rhs: Model) -> Bool {
    return lhs.title.localizedStandardCompare(rhs.title) == .orderedAscending
}

func > (lhs: Model, rhs: Model) -> Bool {
    return lhs.title.localizedStandardCompare(rhs.title) == .orderedDescending
}
