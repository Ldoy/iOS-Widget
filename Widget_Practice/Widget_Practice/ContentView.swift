//
//  ContentView.swift
//  Widget_Practice
//
//  Created by Do Yi Lee on 2021/11/04.
//

import SwiftUI

struct ContentView: View {
    let emojis = [
        Emoji(icon: "🌟", name: "Star", description: "Star Emoji"),
        Emoji(icon: "💚", name: "Heart", description: "Green Heart")
    ]
    var body: some View {
        VStack(spacing: 30) {
            ForEach(emojis) { emoji in
                EmojiView(emoji: emoji)
                    .onTapGesture {
                        save(emoji)
                    }
            }
        }
    }
    
    func save(_ emoji: Emoji) {
        print("save\(emoji)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
