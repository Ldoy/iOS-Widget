//
//  Emoji.swift
//  Widget_Practice
//
//  Created by Do Yi Lee on 2021/11/04.
//

import Foundation

struct Emoji: Identifiable, Codable {
    var id: String { icon }
    
    let icon: String
    let name: String
    let description: String
}
