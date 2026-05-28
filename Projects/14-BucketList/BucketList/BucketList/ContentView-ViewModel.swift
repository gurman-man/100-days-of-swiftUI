//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by mac on 23.05.2026.
//

import LocalAuthentication
import CoreLocation
import Foundation
import MapKit

extension ContentView {
    @Observable
    class ViewModel {
        enum AuthenticationError: Error, LocalizedError {
            case biometryNotAvailable, biometryNotEnrolled, biometryLockout, authenticationFailed, unknownError
            
            // Створюємо ініціалізатор, який приймає системну LAError і сам себе мапить (зіставляє)!
            init(from laError: LAError) {
                switch laError.code {
                case .biometryNotAvailable:     self = .biometryNotAvailable
                case .biometryNotEnrolled:      self = .biometryNotEnrolled
                case .biometryLockout:          self = .biometryLockout
                case .authenticationFailed:     self = .authenticationFailed
                default:                        self = .unknownError
                }
            }
            
            var errorDescription: String? {
                switch self {
                case .biometryNotAvailable: 
                    return "Biometric authentication is not available on this device."
                case .biometryNotEnrolled:
                    return "Face ID / Touch ID is not set up. Please enable it in iPhone settings."
                case .biometryLockout: 
                    return "Too many failed attempts. Face ID / Touch ID is locked."
                case .authenticationFailed:
                    return "Biometric recognition failed. Please try again."
                case .unknownError:
                    return "Unknown error. Please try again later."
                }
            }
        }
        
        private(set) var locations: [Location] // "set" означає що записувати дані про місцезнаходження може лише клас (ViewModel)
        
        // Опціональний стан: коли View присвоює сюди значення, автоматично відкривається .sheet
        var selectedPlace: Location?
        
        var isHybridMap = false // стиль мапи за замовчуванням
        
        var showingError = false
        var authError: AuthenticationError?
        
        var isUnlocked = false
        
        // Шлях куди ми зберігаємо дані (весь наш JSON-масив)
        // Знаходить системний шлях до папки "Документи" на пристрої та додає в кінці назву нашого файлу "SavedPlaces"
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        
        
        // Ініціалізатор: завантажує збережені локації та розкодує їх із JSON при старті додатка
        init() {
            do {
                // намагаємось відкрити файл "SavedPlaces"
                let data = try Data(contentsOf: savePath)
                
                // Декодуємо JSON-дані у масив структур Location
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        
        // Метод для автоматичного збереження локацій на диск
        func save() {
            let encoder = JSONEncoder()
            
            do {
                let data = try encoder.encode(locations)
                
                // Записуємо дані з додатковими параметрами безпеки:
                // .atomic - захищає від втрати даних при збої
                // .completeFileProtection - файл шифрується і доступний лише тоді, коли пристрій розблоковано
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        
        // Логіка додавання нової точки на мапі
        func addLocation(at point: CLLocationCoordinate2D) {
            let newLocation = Location(
                id: UUID(),
                name: "New Location",
                description: "",
                latitude: point.latitude,
                longitude: point.longitude)
            
            locations.append(newLocation) // Оновлюємо масив усередині класу
            save()
        }
        
        
        // Логіка оновлення існуючої точки після редагування
        func update(location: Location) {
            guard let selectedPlace else { return }
            
            // Шукаємо індекс старої точки (place) і замінюємо її оновленою (newLocation)
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }
        
        
        // Метод для налаштування authentication користувача
        func authenticate() {
            // Екземляр для запуску процесу сканування
            let context = LAContext()
            var error: NSError?
            
            // Крок 1: Перевіряємо, чи взагалі на пристрої є Face ID/Touch ID і чи вони налаштовані
            // .deviceOwnerAuthenticationWithBiometrics — перевірка саме пальцем/обличчям
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                
                // Крок 2: Запускаємо процес сканування
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    
                    // Крок 3: Обробляємо результат
                    DispatchQueue.main.async {
                        guard success else {
                            // Якщо сталася помилка — фіксуємо її та показуємо алерт
                            self.isUnlocked = false
                            
                            // Challenge 2
                            if let laError = authenticationError as? LAError {
                                // Ігноруємо випадок, коли користувач просто сам натиснув "Cancel"
                                if laError.code == .userCancel { return }
                                
                                // Мапінг відбувається автоматично завядки init(from:)
                                self.authError = AuthenticationError(from: laError)
                                self.showingError = true
                            }
                            return
                        }
                        
                        // Якщо аутентифікація успішна — розблоковуємо додаток!
                        self.isUnlocked = true
                    }
                }
            } else {
                // Немає біометрії на пристрої (можна додати альтернативний вхід)
                DispatchQueue.main.async {
                    // Challenge 2
                    if let laError = error as? LAError, laError.code == .biometryNotEnrolled {
                        self.authError = .biometryNotEnrolled
                    } else {
                        self.authError = .biometryNotAvailable
                    }
                    self.showingError = true
                }
            }
        }
        
    }
}
