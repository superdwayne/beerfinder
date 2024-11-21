import SwiftUI

struct WishlistView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var wishlistManager: WishlistManager
    let cards: [Card]
    
    var wishlistedCards: [Card] {
        cards.filter { wishlistManager.isWishlisted($0.id) }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 20) {
                    ForEach(wishlistedCards) { card in
                        CardView(
                            card: card,
                            onTap: { _ in 
                                // Optional: handle tap in wishlist view
                            }
                        )
                        .frame(height: 200)
                    }
                }
                .padding()
            }
            .navigationTitle("Wishlist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
} 
