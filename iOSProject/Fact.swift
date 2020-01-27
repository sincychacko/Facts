//
//  Fact.swift
//  iOSProject
//
//  Created by SINCY on 27/01/20.
//  Copyright © 2020 SINCY. All rights reserved.
//

import Foundation
import UIKit

struct FactInfo: Codable {
    var title: String
    var facts: [Fact]
    
    enum CodingKeys: String, CodingKey {
        case title, facts = "rows"
    }
}

struct Fact: Codable {
    var title: String?
    var description: String?
    var imageName: String?
    var factImage: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case title, description, imageName = "imageHref"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        imageName = try container.decodeIfPresent(String.self, forKey: .imageName)
    }
}
