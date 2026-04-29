//
//  DetaiView.swift
//  FriendFace
//
//  Created by mac on 14.04.2026.
//

import SwiftUI

// MARK: - View Modifiers

struct CardBackground: ViewModifier {
    var material: AnyShapeStyle
    var shadowColor: Color // Додаємо параметр для кольору тіні
    
    func body(content: Content) -> some View {
        
        content
            .listRowBackground(
                RoundedRectangle(cornerRadius: 20)
                    .fill(material)
                    .shadow(color: shadowColor, radius: 3)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
            )
            .listRowSeparator(.hidden)
    }
}

extension View {
    func cardStyle(
        material: AnyShapeStyle = AnyShapeStyle(.ultraThinMaterial),
        shadowColor: Color = .black
    ) -> some View {
        modifier(CardBackground(material: material, shadowColor: shadowColor))
    }
}

// MARK: - Main View

struct DetailView: View {
    let user: User
    @State private var isAboutExpanded = false
    
    // Динамічний колір залежно від статусу
    private var themeColor: Color {
        user.isActive ? .blue : .secondary
    }
    
    var body: some View {
        List {
            headerSection
                .cardStyle(shadowColor: themeColor)
    
            aboutSection
                .cardStyle(material: AnyShapeStyle(.thinMaterial), shadowColor: themeColor)
            
            contactsSection
                .cardStyle(material: AnyShapeStyle(.thickMaterial), shadowColor: themeColor)
            
            friendsSection
            
            userTags
        }
        .navigationTitle("\(user.name)")
        .navigationBarTitleDisplayMode(.inline)
        .scrollContentBackground(.hidden) // Дозволяє бачити фон за списком: наш градієнт
        .background(BackgroundGradientView())
    }
}


// MARK: - Subviews Extension

private extension DetailView {
    
    private var headerSection: some View {
        Section {
            VStack(spacing: 15) {
                HStack(spacing: 20) {
                    AvatarView(isActive: user.isActive, color: themeColor)
                    
                    VStack (alignment: .leading, spacing: 10) {
                        Text(user.name)
                            .font(.title2.bold())
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(2)
                        
                        HStack(spacing: 6) {
                            Text("\(user.age) years old")
                            Text("•")
                            Text(user.isActive ? "Online" : "Offline")
                                .foregroundStyle(themeColor)
                            Text("•")
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                    }
                }
                Divider()
                HStack {
                    Text("Member since \(user.registered.formatted(date: .long, time: .omitted))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .padding()
        }
    }
    
    
    private var aboutSection: some View {
        Section("About") {
            VStack(alignment: .leading, spacing: 8) {
                Text(user.about)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .lineLimit(isAboutExpanded ? nil : 3)
                
                ExpandButton(isExpanded: $isAboutExpanded, color: themeColor)
            }
            .padding()
        }
    }
    
    
    private var contactsSection: some View {
        Section("Contacts") {
            VStack(alignment: .leading, spacing: 12) {
                ContactRow(icon: "building.2.fill", label: "Company", value: user.company)
                Divider()
                ContactRow(icon: "envelope.fill", label: "Email", value: user.email)
                Divider()
                ContactRow(icon: "mappin.and.ellipse", label: "Address", value: user.address)
            }
            .padding()
        }
    }
    
    
    private var friendsSection: some View {
        Section("Friends") {
            ForEach(user.friends) { friend in
                HStack {
                    Image(systemName: "person.crop.circle")
                        .foregroundStyle(.blue)
                    Text(friend.name)
                }
                .padding(.vertical, 4)
            }
        }
    }
    
    
    private var userTags: some View {
        Section ("Tags") {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(user.tags, id: \.self) { tag in
                        Text("#\(tag)")
                            .font(.caption)
                            .fontWeight(.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.blue.opacity(0.1))
                            .foregroundStyle(.blue)
                            .clipShape(Capsule())
                    }
                }
                .padding(.vertical, 5)
            }
        }
    }

}


// MARK: - Extracted Components

struct AvatarView: View {
    let isActive: Bool
    let color: Color
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundStyle(.black.gradient.opacity(0.7))
            
            Circle()
                .fill(color)
                .frame(width: 25, height: 25)
                .overlay(Circle().stroke(.black.opacity(0.9), lineWidth: 4))
        }
    }
}

struct ContactRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack (spacing: 20) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            VStack(alignment: .leading) {
                Text(label).font(.caption).foregroundStyle(.secondary)
                Text(value).font(.body)
            }
        }
    }
}

struct ExpandButton: View {
    @Binding var isExpanded: Bool
    let color: Color
    
    var body: some View {
        Button {
            withAnimation(.spring()) { isExpanded.toggle() }
        } label: {
            HStack {
                Text(isExpanded ? "Less" : "Show more")
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
            }
            .font(.caption.bold())
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.top, 5)
    }
}

struct BackgroundGradientView: View {
    var body: some View {
        LinearGradient(
            colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.3), .clear],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    DetailView(user: User(
        id: "1",
        isActive: true,
        name: "Maksym Ivasechko",
        age: 20,
        company: "TNTU",
        email: "maksym@tntu.edu.ua",
        address: "Ternopil, Ukraine",
        about: "Aspiring iOS Developer learning SwiftUI.",
        registered: .now,
        tags: ["Swift", "SwiftUI", "iOS"],
        friends: []
    ))
    .modelContainer(for: User.self, inMemory: true)
}
