//
//  EmojiView.swift
//  Widget_Practice
//
//  Created by Do Yi Lee on 2021/11/04.
//

import SwiftUI

struct EmojiView: View {
    let emoji: Emoji
    var body: some View {
        Text(emoji.icon)
    }
    
}

//struct EmojiView_Previews: PreviewProvider {
//    static var previews: some View {
//        EmojiView(emoji: Emoji)
//    }
//}
