import SwiftUI

struct InfiniteGridView: View {
    @StateObject private var wishlistManager = WishlistManager()
    @State private var cards: [Card] = []
    @State private var contentOffset: CGPoint = .zero
    @GestureState private var dragOffset: CGSize = .zero
    @State private var animatingHearts: [(id: UUID, position: CGPoint)] = []
    @State private var showingConfetti = false
    @State private var showingMatchText = false
    @State private var lastSelectedTitle: String?
    
    let spacing: CGFloat = 30
    let columns = 1
    let cardSize: CGFloat = UIScreen.main.bounds.width - 100
    
    // Add beer images array
    private let beerImages = ["beer1", "beer2", "beer3", "beer4", "beer5"]
    
    // Add bar names array
    private let barNames = [
        "The Rusty Barrel",
        "Hoppy Hour Haven",
        "The Tipsy Tap",
        "Craft & Draft",
        "The Beer Garden",
        "Brew & Co.",
        "The Local Pub",
        "Malt & Hops",
        "The Thirsty Scholar",
        "Barley's Bar",
        "The Brew House",
        "Pint Perfect",
        "The Ale House",
        "The Crafty Pint",
        "Beer Republic"
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geometry in
                ZStack {
                    Color.black.edgesIgnoringSafeArea(.all)
                    
                    // Main content
                    ZStack {
                        ForEach(cards) { card in
                            CardView(card: card,
                                   onTap: { position in
                                handleCardTap(card.id, position: position)
                            })
                            .frame(width: cardSize, height: cardSize * 1.2)
                            .position(
                                x: geometry.size.width/2 + CGFloat(card.gridPosition.col) * (cardSize + spacing) + contentOffset.x + dragOffset.width,
                                y: geometry.size.height/2 + CGFloat(card.gridPosition.row) * (cardSize * 1.2 + spacing) + contentOffset.y + dragOffset.height
                            )
                        }
                        
                        // Animated hearts layer
                        ForEach(animatingHearts, id: \.id) { heart in
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 40))
                                .position(heart.position)
                        }
                        
                        // Match text
                        if showingMatchText {
                            Text("It's a Match!")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.5), radius: 4)
                                .transition(.scale.combined(with: .opacity))
                        }
                        
                        // Confetti
                        ConfettiView(isShowing: $showingConfetti)
                    }
                    .gesture(
                        DragGesture()
                            .updating($dragOffset) { value, state, _ in
                                state = value.translation
                            }
                            .onEnded { value in
                                contentOffset.x += value.translation.width
                                contentOffset.y += value.translation.height
                                generateCardsIfNeeded()
                            }
                    )
                }
            }
            
            // Bottom Navigation Bar
            BottomNavBar(wishlistCount: wishlistManager.wishlistedCards.count)
        }
        .ignoresSafeArea(.keyboard)
        .environmentObject(wishlistManager)
        .onAppear {
            generateInitialCards()
        }
    }
    
    private func handleCardTap(_ cardId: UUID, position: CGPoint) {
        if let index = cards.firstIndex(where: { $0.id == cardId }) {
            let isCurrentlySelected = cards[index].selectionTime != nil
            
            withAnimation(.spring(response: 0.3)) {
                if isCurrentlySelected {
                    cards[index].selectionTime = nil
                    animateHeartsRemoval(from: position, for: cardId)
                    lastSelectedTitle = nil
                } else {
                    cards[index].selectionTime = Date()
                    animateHeartsToWishlist(from: position, for: cardId)
                    
                    // Check for match
                    if let lastTitle = lastSelectedTitle {
                        if lastTitle == cards[index].title {
                            // It's a match!
                            withAnimation {
                                showingMatchText = true
                                showingConfetti = true
                            }
                            
                            // Hide match text after delay
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showingMatchText = false
                                }
                            }
                            
                            // Add haptic feedback
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.success)
                        }
                        lastSelectedTitle = nil
                    } else {
                        lastSelectedTitle = cards[index].title
                    }
                }
            }
        }
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    private func animateHeartsToWishlist(from position: CGPoint, for cardId: UUID) {
        // Create multiple hearts for a more dynamic animation
        for i in 0...2 {
            let heart = (id: UUID(), position: position)
            animatingHearts.append(heart)
            
            // Calculate slightly different target positions for each heart
            let targetY = UIScreen.main.bounds.height - 49
            let targetX = UIScreen.main.bounds.width * 0.75 + CGFloat(i * 10 - 10)
            
            // Animate each heart with slightly different timing
            withAnimation(
                .interpolatingSpring(
                    duration: 0.6,
                    bounce: 0.3
                )
                .delay(Double(i) * 0.1)
            ) {
                if let index = animatingHearts.firstIndex(where: { $0.id == heart.id }) {
                    animatingHearts[index].position = CGPoint(x: targetX, y: targetY)
                }
            }
            
            // Remove the animated heart after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7 + Double(i) * 0.1) {
                animatingHearts.removeAll { $0.id == heart.id }
            }
        }
        
        // Update wishlist
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            wishlistManager.toggleWishlist(for: cardId)
        }
    }
    
    private func animateHeartsRemoval(from position: CGPoint, for cardId: UUID) {
        // Create multiple hearts starting from the wishlist icon
        for i in 0...2 {
            let startY = UIScreen.main.bounds.height - 49
            let startX = UIScreen.main.bounds.width * 0.75 + CGFloat(i * 10 - 10)
            
            let heart = (id: UUID(), position: CGPoint(x: startX, y: startY))
            animatingHearts.append(heart)
            
            // Animate each heart with slightly different timing
            withAnimation(
                .interpolatingSpring(
                    duration: 0.6,
                    bounce: 0.3
                )
                .delay(Double(i) * 0.1)
            ) {
                if let index = animatingHearts.firstIndex(where: { $0.id == heart.id }) {
                    animatingHearts[index].position = position
                }
            }
            
            // Remove the animated heart after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7 + Double(i) * 0.1) {
                animatingHearts.removeAll { $0.id == heart.id }
            }
        }
        
        // Update wishlist
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            wishlistManager.toggleWishlist(for: cardId)
        }
    }
    
    private func generateInitialCards() {
        // Generate a larger initial grid
        for row in -4...4 {
            for col in -4...4 {
                let card = createCard(at: GridPosition(row: row, col: col))
                cards.append(card)
            }
        }
    }
    
    private func createCard(at position: GridPosition) -> Card {
        Card(
            title: barNames[Int.random(in: 0..<barNames.count)],  // Randomly select a bar name
            content: "Tap to explore!",
            gridPosition: position,
            imageName: beerImages[Int.random(in: 0..<beerImages.count)],
            selectionTime: nil
        )
    }
    
    private func generateRandomColor(for position: GridPosition) -> Color {
        // Generate consistent color based on position
        let hue = abs(Double(position.row + position.col)).truncatingRemainder(dividingBy: 1.0)
        return Color(hue: hue, saturation: 0.7, brightness: 0.9)
    }
    
    private func generateCardsIfNeeded() {
        let viewportCenter = CGPoint(
            x: -contentOffset.x,
            y: -contentOffset.y
        )
        
        // Calculate visible range
        let visibleRange = 5 // Number of cards visible in each direction
        let currentCenterRow = Int(round(viewportCenter.y / (cardSize + spacing)))
        let currentCenterCol = Int(round(viewportCenter.x / (cardSize + spacing)))
        
        // Generate new cards in all directions
        for row in (currentCenterRow - visibleRange)...(currentCenterRow + visibleRange) {
            for col in (currentCenterCol - visibleRange)...(currentCenterCol + visibleRange) {
                let position = GridPosition(row: row, col: col)
                if !cards.contains(where: { $0.gridPosition == position }) {
                    let card = createCard(at: position)
                    cards.append(card)
                }
            }
        }
        
        // Remove cards that are far from view
        removeDistantCards(from: viewportCenter)
    }
    
    private func removeDistantCards(from center: CGPoint) {
        let removeRange = 8 // Cards further than this will be removed
        let currentCenterRow = Int(round(center.y / (cardSize + spacing)))
        let currentCenterCol = Int(round(center.x / (cardSize + spacing)))
        
        cards.removeAll { card in
            let rowDistance = abs(card.gridPosition.row - currentCenterRow)
            let colDistance = abs(card.gridPosition.col - currentCenterCol)
            return rowDistance > removeRange || colDistance > removeRange
        }
    }
}

// Add a preview for testing
#Preview {
    InfiniteGridView()
} 