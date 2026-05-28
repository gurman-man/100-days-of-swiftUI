//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by mac on 27.05.2026.
//

import Foundation

// Challenge 3
extension EditView {
    @Observable
    class ViewModel {
        
        // Перелік усіх можливих станів завантаження для UI
        enum LoadingState {
            case loading, loaded, failed
        }
        
        var pages = [Page]() // Масив для збереження отриманих сторінок Вікіпедії
        var loadingState = LoadingState.loading // Початковий стан — завантаження мережі
        
        // private(set) гарантує, що локацію можна читати ззовні, але змінювати — тільки всередині класу
        private(set) var location: Location
        
        // Стан для текстових полів: SwiftUI зв'язується з ними напряму через $viewModel
        var name: String
        var description: String
        
        // Ініціалізатор приймає початкову точку та наповнює поля форми при старті
        init(location: Location) {
            self.name = location.name
            self.description = location.description
            self.location = location
        }
        
        // Формує оновлену локацію для збереження
        var updateLocation: Location {
            Location(
                id: location.id,
                name: name,
                description: description,
                latitude: location.latitude,
                longitude: location.longitude
            )
        }
        
        
        // @MainActor гарантує, що результати запиту (pages та loadingState) оновлять UI безпечно в головному потоці
        @MainActor
        func fetchNearbyPlaces() async {
            // Асинхронна функція для завантаження даних з Wikipedia
            // Формуємо URL-рядок, підставляючи координати поточної локації
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
            
            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                return
            }
            
            do {
                // Виконуємо мережевий запит
                let (data, _) = try await URLSession.shared.data(from: url)
                
                // Декодуємо отриманий JSON у наші структури
                let items = try JSONDecoder().decode(Result.self, from: data)
                
                // Успіх - конвертуємо наші значення масиву у масив сторінок та сортуємо за алфавітом (завдяки Comparable)
                pages = items.query.pages.values.sorted()
                loadingState = .loaded
            } catch {
                loadingState = .failed
            }
        }
        
    }
}
