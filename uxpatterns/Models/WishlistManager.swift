import SwiftUI

class WishlistManager: ObservableObject {
    @Published var wishlistedCards: Set<UUID> = []
    
    func toggleWishlist(for cardId: UUID) {
        if wishlistedCards.contains(cardId) {
            wishlistedCards.remove(cardId)
        } else {
            wishlistedCards.insert(cardId)
        }
    }
    
    func isWishlisted(_ cardId: UUID) -> Bool {
        wishlistedCards.contains(cardId)
    }
} 