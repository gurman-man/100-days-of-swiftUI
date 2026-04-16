//
//  DetaiView.swift
//  FriendFace
//
//  Created by mac on 14.04.2026.
//

import SwiftUI

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

struct DetailView: View {
    let user: User
    
    @State private var isAboutExpanded = false
    
    var body: some View {
        List {
            
            // 1. Хедер з аватаркою та основним статусом
            headerSection
                .cardStyle(shadowColor: statusColor)
            
            
            // Секція Про себе
            aboutSection
                .cardStyle(material: AnyShapeStyle(.thinMaterial), shadowColor: statusColor)
            
            contactsSection
                .cardStyle(material: AnyShapeStyle(.thickMaterial), shadowColor: statusColor)
            
            friendsSection
            
            userTags
        }
        .navigationTitle("\(user.name)")
        .navigationBarTitleDisplayMode(.inline)
        .scrollContentBackground(.hidden) // Дозволяє бачити фон за списком: наш градієнт
        .background(
            LinearGradient(
                    colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.3), .clear],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
        )
    }
    
    private var headerSection: some View {
        Section {
            VStack(spacing: 15) {
                
                HStack(spacing: 20) {
                    avatarView
                    
                    VStack (alignment: .leading, spacing: 10) {
                        Text(user.name)
                            .font(.title2.bold())
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(2)
                        
                        HStack(spacing: 6) {
                            Text("\(user.age) years old")
                            Text("•")
                            Text(user.isActive ? "Online" : "Offline")
                                .foregroundStyle(statusColor)
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
    
    private var avatarView: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundStyle(.black.gradient.opacity(0.7))
            
            Circle()
                .fill(statusColor)
                .frame(width: 25, height: 25)
                .overlay(Circle().stroke(.black, lineWidth: 4))
        }
    }
    
    private var aboutSection: some View {
        Section("About") {
            VStack(alignment: .leading) {
                Text(user.about)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .lineLimit(isAboutExpanded ? nil : 3)
                
                Button {
                    withAnimation(.spring()) {
                        isAboutExpanded.toggle()
                    }
                } label: {
                    HStack {
                        Text(isAboutExpanded ? "Less" : "Show more")
                        Image(systemName: isAboutExpanded ? "chevron.up" : "chevron.down")
                    }
                    .font(.caption.bold())
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 5)
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
                        .foregroundStyle(statusColor)
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
    
    
    private var statusColor: Color {
        user.isActive ? .blue : .secondary
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
        friends: [
            User.Friend(id: "2", name: "Oleh"),
            User.Friend(id: "3", name: "Iryna")
        ]
    ))
}
