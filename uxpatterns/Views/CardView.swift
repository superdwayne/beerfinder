import SwiftUI

struct CardView: View {
    let card: Card
    let onTap: (CGPoint) -> Void
    @EnvironmentObject var wishlistManager: WishlistManager
    @Environment(\.displayScale) var displayScale
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 24) {
                Text(card.title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                
                Text(card.content)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                    .multilineTextAlignment(.center)
                
                if wishlistManager.isWishlisted(card.id) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 32))
                        .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                }
            }
            .padding(32)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image(card.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.black.opacity(0.5),
                                Color.black.opacity(0.3)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .overlay(
                card.selectionTime != nil ?
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.white, lineWidth: 4)
                    .animation(.spring(response: 0.3), value: card.selectionTime)
                : nil
            )
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.white.opacity(0.5), lineWidth: 8)
                    .blur(radius: 8)
                    .opacity(card.selectionTime != nil ? 1 : 0)
            )
            .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 6)
            .gesture(
                TapGesture()
                    .onEnded { _ in
                        let center = CGPoint(
                            x: geometry.frame(in: .global).midX,
                            y: geometry.frame(in: .global).midY
                        )
                        onTap(center)
                    }
            )
        }
    }
} 