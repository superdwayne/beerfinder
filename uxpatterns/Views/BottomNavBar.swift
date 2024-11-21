import SwiftUI

struct BottomNavBar: View {
    let wishlistCount: Int
    
    var body: some View {
        HStack {
            Spacer()
            NavBarItem(icon: "house.fill", text: "Home")
            Spacer()
            NavBarItem(icon: "magnifyingglass", text: "Search")
            Spacer()
            NavBarItem(icon: "heart.fill", text: "Wishlist", count: wishlistCount)
            Spacer()
            NavBarItem(icon: "person.fill", text: "Profile")
            Spacer()
        }
        .padding(.vertical, 12)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .edgesIgnoringSafeArea(.bottom)
        )
        // Add safe area padding at the bottom
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 0)
        }
    }
}

struct NavBarItem: View {
    let icon: String
    let text: String
    var count: Int? = nil
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                
                if let count = count, count > 0 {
                    Text("\(count)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.red)
                        .clipShape(Circle())
                        .offset(x: 12, y: -12)
                }
            }
            
            Text(text)
                .font(.caption2)
                .foregroundColor(.white)
        }
    }
} 