import SwiftUI

struct ConfettiView: View {
    @Binding var isShowing: Bool
    let duration: Double = 3
    
    var body: some View {
        ZStack {
            ForEach(0..<50) { _ in
                ConfettiPiece(isShowing: $isShowing)
            }
        }
        .onChange(of: isShowing) { newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    isShowing = false
                }
            }
        }
    }
}

struct ConfettiPiece: View {
    @State private var position = CGPoint(x: 0, y: 0)
    @State private var rotation = 0.0
    @State private var scale: CGFloat = 0.01
    @Binding var isShowing: Bool
    
    let colors: [Color] = [.red, .blue, .green, .yellow, .pink, .purple, .orange]
    
    var body: some View {
        Circle()
            .fill(colors.randomElement()!)
            .frame(width: 10, height: 10)
            .scaleEffect(scale)
            .position(x: position.x, y: position.y)
            .rotationEffect(.degrees(rotation))
            .opacity(isShowing ? 1 : 0)
            .onChange(of: isShowing) { newValue in
                if newValue {
                    let screenWidth = UIScreen.main.bounds.width
                    let screenHeight = UIScreen.main.bounds.height
                    
                    position = CGPoint(
                        x: screenWidth / 2,
                        y: screenHeight / 2
                    )
                    
                    withAnimation(.spring(duration: 3)) {
                        position = CGPoint(
                            x: CGFloat.random(in: 0...screenWidth),
                            y: CGFloat.random(in: 0...screenHeight)
                        )
                        rotation = Double.random(in: 0...360) * 5
                        scale = CGFloat.random(in: 0.5...1.5)
                    }
                }
            }
    }
} 