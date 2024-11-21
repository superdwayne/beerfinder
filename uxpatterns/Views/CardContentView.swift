import SwiftUI

struct CardContentView: View {
    let title: String
    let content: String
    let backgroundColor: Color
    
    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .shadow(radius: 2)
            
            Text(content)
                .font(.system(size: 18))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .shadow(radius: 1)
        }
        .padding(24)
        .frame(width: 300, height: 400)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(backgroundColor)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
} 