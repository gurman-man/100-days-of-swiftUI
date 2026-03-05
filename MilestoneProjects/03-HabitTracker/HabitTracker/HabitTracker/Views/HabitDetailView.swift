//
//  DetailView.swift
//  HabitTracker
//
//  Created by mac on 05.03.2026.
//

import SwiftUI

struct HabitDetailView: View {
    @Binding var habit: Habit // дозволить змінити @State property в іншому View
    @State private var showConfetti = false
    @State private var gaugeScale: CGFloat = 1.0 // Початковий масштаб 1.0
    
    // Обчислюємо відсоток для статистики
    var progressPercentage: Int {
        guard habit.goal > 0 else { return 0 }
        let percentage = (Double(habit.completionCount) / Double(habit.goal)) * 100
        return Int(min(percentage, 100))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            Spacer(minLength: 20) // Гнучкий відступ зверху
            
            // 1. Секція прогресу
            ZStack {
                Gauge(value: Double(habit.completionCount), in: 0...Double(habit.goal)) {
                    Text("")
//                    Image(systemName: habit.icon)
//                        .font(.system(size: 20))
                }
                .gaugeStyle(.accessoryCircularCapacity)
                .tint(habit.completionCount >= habit.goal ? habit.color.swiftUIColor : habit.color.swiftUIColor.opacity(0.5))
                .scaleEffect(2)
                .shadow(color: habit.color.swiftUIColor, radius: 20)
                
                // Шар 2: Текст, який ми центруємо вручну
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text("\(progressPercentage)")
                        .font(.system(size: 28, weight: .black, design: .rounded)) // Розмір підібрано під scaleEffect
                    Text("%")
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            }
            .scaleEffect(gaugeScale)
            .scaleEffect(showConfetti ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 0.5).repeatCount(3), value: showConfetti)
            .frame(height: 150)
            .padding(.top, 40)
            
            Spacer(minLength: 30) // Відштовхує картку від Gauge
            
            // 2. Інформаційний блок
            VStack(spacing: 15) {
                if !habit.description.isEmpty {
                    Text(habit.description)
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                
                Text("\(habit.completionCount) of \(habit.goal) times")
                    .font(.system(size: 18, weight: .light))
                    .italic()
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 30)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .padding(.horizontal, 25)
            
            Spacer(minLength: 80) // Максимальний простір перед кнопками
            
            // 3. Секція дій (Кнопки)
            HStack(spacing: 40) {
                
                // Кнопка Мінус (для відміни помилкового натискання)
                Button {
                    withAnimation(.snappy) {
                        if habit.completionCount > 0 {
                            habit.completionCount -= 1
                            triggerHaptic(.light)
                            showConfetti = false
                        }
                    }
                } label: {
                    Image(systemName: "minus")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(habit.color.swiftUIColor)
                        .frame(width: 90, height: 90)
                        .background(habit.color.swiftUIColor.opacity(0.3))
                        .clipShape(Circle())
                }
                
                // Головна кнопка Плюс
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        completionAction()
                    }
                } label: {
                    Image(systemName: habit.completionCount >= habit.goal ? "checkmark" : "plus")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 90, height: 90)
                        .background(habit.completionCount >= habit.goal ? Color.green : habit.color.swiftUIColor)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                }
                .disabled(habit.completionCount >= habit.goal) // Блокуємо, якщо ціль досягнута
            }
            .padding(.bottom, 20) // Відступ від низу екрана
            
            Spacer()
            
        }
        .navigationTitle($habit.title)
        .navigationBarTitleDisplayMode(.inline)
        // НАКЛАДАЄМО ЕФЕКТ КОНФЕТІ (якщо ціль досягнута)
        .overlay {
            if showConfetti {
                ConfettiEffectView() // Наша кастомна анімація
            }
        }
    }
    
    
    func completionAction() {
        if habit.completionCount < habit.goal {
            habit.completionCount += 1
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                gaugeScale = 1.3 // Збільшуємо на 30%
            }
            
            // Повертаємо назад через мить
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    gaugeScale = 1.0
                }
            }
            
            if habit.completionCount == habit.goal {
                // Подвійна вібрація для тріумфу
                triggerSuccessHaptic()
                
                showConfetti = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    withAnimation {
                        showConfetti = true // запускаємо конфеті
                    }
                }
            } else {
                // Звичайна вібрація для кроку
                triggerHaptic(.medium)
            }
        }
    }
    
    // Покращений тактильний відгук
    func triggerHaptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    func triggerSuccessHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

#Preview {
    HabitDetailView(habit: .constant(Habit(
        id: UUID(),
        title: "Wake Up",
        description: "at 06:00 AM",
        completionCount: 5,
        category: .health,
        icon: "figure.run",
        color: .red,
        goal: 1)))
}
