//
//  DetailView.swift
//  HabitTracker
//
//  Created by mac on 05.03.2026.
//

import SwiftUI

struct LiquidStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 30)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .padding(.horizontal, 25)
    }
}

// Додаємо зручний метод для виклику
extension View {
    func liquidStyle() -> some View {
        modifier(LiquidStyle())
    }
}

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
        ZStack {
            // Фоновий блюр
            habit.color.swiftUIColor
                .opacity(0.1) // Дуже слабкий колір
                .blur(radius: 50)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer(minLength: 20)
                
                // 1. Нерухома секція прогресу
                progressHeader
                
                // 2. Секція карток, що прокручується
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        if !habit.description.isEmpty {
                            notesCard
                        }
                        
                        additionalCards
                    }
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                }
                
                // 3. Нерухома секція кнопок
                actionButtons
                    .padding(.bottom, 30)
            }
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
    
    
    // MARK: - Секція Gauge
    private var progressHeader: some View {
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
        .animation(.spring(duration: 0.5).repeatCount(3), value: showConfetti)
        .frame(height: 150)
        .padding(.top, 40)
    }
    
    
    // MARK: - Картка нотаток
    private var notesCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Notes")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
            
            Text(habit.description)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .fixedSize(horizontal: false, vertical: true) // Дозволяє тексту рости вниз
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .liquidStyle()
    }
    
    // MARK: - Решта карток (Progress, Strength тощо)
    private var additionalCards: some View {
        Group {
            // Картка 1: Цифровий прогрес
            HStack {
                Label("Progress", systemImage: "chart.bar.fill")
                    .font(.headline)
                Spacer()
                Text("\(habit.completionCount) / \(habit.goal)")
                    .font(.system(.body, design: .monospaced).bold())
            }
            .liquidStyle()
            
            
            // Картка 2: Датований прогрес
            HStack {
                Image(systemName: "clock.fill").foregroundStyle(.blue)
                Text("Last Done").font(.headline)
                Spacer()
                Text(habit.lastCompletionDate?.formatted(date: .abbreviated, time: .omitted) ?? "Never") // Тут потім підставиш дату
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .liquidStyle()
            
            // Картка 3: Стрік (Consistency)
            HStack {
                Image(systemName: "flame.fill").foregroundStyle(.orange)
                Text("Current Streak").font(.headline)
                Spacer()
                Text(" \(habit.currentStreak) days")
                    .font(.system(.body, design: .rounded).bold())
                    .foregroundStyle(.orange)
            }
            .liquidStyle()
        }
    }
    
    // MARK: - Кнопки дій
    
    private var actionButtons: some View {
        HStack(spacing: 40) {
            // Кнопка Мінус (для відміни помилкового натискання)
            Button {
                withAnimation(.snappy) {
                    if habit.completionCount > 0 {
                        habit.completionCount -= 1
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
    }
    
    
    // MARK: - Functions
    
    func completionAction() {
        guard habit.completionCount < habit.goal else { return }
        
        // 1. Логіка даних
        updateHabitStats()
        
        // 2. Анімація Gauge
        animateGauge()
        
        // 3. Завершення Confetti
        if habit.completionCount == habit.goal {
            handleGoalCompletion()
        }
    }
    
    
    // MARK: - Additional helpers
    private func updateHabitStats() {
        let calendar = Calendar.current
        let today = Date()
        
        // 1. Оновлюємо кількість виконань
        habit.completionCount += 1
        
        if let lastDate = habit.lastCompletionDate {
            if calendar.isDateInYesterday(lastDate) {
                // Виконано вчора — продовжуємо стрік
                habit.currentStreak += 1
            } else if !calendar.isDateInToday(lastDate) {
                habit.currentStreak = 1
            } else {
                // Була перерва — стрік починається заново
                habit.currentStreak = 1
            }
        } else {
            // Перше виконання в історії
            habit.currentStreak = 1
        }
        
        // 3. Оновлюємо дату останнього виконання
        habit.lastCompletionDate = today
    }
    
    
    private func animateGauge() {
        // Анімації та тактильний відгук
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
            gaugeScale = 1.3 // Збільшуємо на 30%
        }
        
        // Повертаємо назад через мить
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                gaugeScale = 1.0
            }
        }
    }
    
    private func handleGoalCompletion() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            withAnimation {
                showConfetti = true
            }
        }
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
