//
//  ContentViewChallenge.swift
//  ViewsAndModifiers
//
//  Created by mac on 13.01.2026.
//

// MARK: - Challenges
/*
    1. Go back to project 1 and use a conditional modifier to change the total amount text view to red if the user selects a 0% tip.
 
    2. Go back to project 2 and replace the Image view used for flags with a new FlagImage() view that renders one flag image using the specific set of modifiers we had.
 
    3. Create a custom ViewModifier (and accompanying View extension) that makes a view have a large, blue font suitable for prominent titles in a view.
*/

import SwiftUI

// MARK: - Custom modifiers
struct ProminentTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.blue)
            .bold()
    }
}

struct CustomItalicTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.body)
            .foregroundStyle(.red)
            .italic()
    }
}


struct CardStyle: ViewModifier {
    var backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .padding()
            .font(.title)
            .background(backgroundColor)
            .clipShape(.rect(cornerRadius: 10))
            .shadow(radius: 5)
    }
}

// MARK: - Extensions
extension View {
    func prominentTitle() -> some View {
        modifier(ProminentTitle())
    }
    
    func asCard(color: Color = .gray) -> some View {
        modifier(CardStyle(backgroundColor: color))
    }
    
    func customItalicTitle() -> some View {
        modifier(CustomItalicTitle())
    }
}

// MARK:  - Main Content
struct ContentViewChallenge: View {
    var body: some View {
        
        VStack {
            VStack(spacing: 20) {
                Text("Your custom title")
                    .prominentTitle()
                    .padding()
                    .background(.white)
                    .clipShape(.capsule)
                
                Text("Just a Card")
                    .asCard(color: .green)
                    .foregroundStyle(.primary)
                
                Text("Italic title")
                    .customItalicTitle()
                    .padding(50)
                    .background(.black)
                    .clipShape(.circle)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.yellow)
        .ignoresSafeArea()
    }
}

#Preview {
    ContentViewChallenge()
}
