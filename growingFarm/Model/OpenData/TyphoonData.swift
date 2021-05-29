//
//  TyphoonData.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/5/27.
//  Copyright © 2021 Michael. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct TyphoonData: Codable {
    let id: String
    let title: String
    let updated: Date
    let entry: [Entry]
}
struct Entry:Codable{
    let id:String
    let link: Link
}
struct Link: Codable {
    let href: String
    enum CodingKeys: String, CodingKey {
        case href = "@href"
    }
}

