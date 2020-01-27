//
//  Fact.swift
//  iOSProject
//
//  Created by SINCY on 27/01/20.
//  Copyright © 2020 SINCY. All rights reserved.
//

import Foundation
import UIKit

struct FactInfo: Codable, Equatable {
    var title: String
    var facts: [Fact]
    
    enum CodingKeys: String, CodingKey {
        case title, facts = "rows"
    }
}

struct Fact: Codable, Equatable {
    var title: String?
    var description: String?
    var imageName: String?
    var factImage: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case title, description, imageName = "imageHref"
    }
}
