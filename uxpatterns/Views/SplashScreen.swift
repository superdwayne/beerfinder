import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @State private var rotation = -30.0
    @State private var bubbles: [(id: UUID, position: CGPoint, size: CGFloat)] = []
    
    var body: some View {
        if isActive {
            InfiniteGridView()
        } else {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                // Animated bubbles
                ForEach(bubbles, id: \.id) { bubble in
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: bubble.size, height: bubble.size)
                        .position(bubble.position)
                }
                
                VStack {
                    ZStack {
                        Image(systemName: "mug.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                            .rotationEffect(.degrees(rotation))
                            .shadow(color: .white.opacity(0.3), radius: 10)
                        
                        // Foam
                        Circle()
                            .fill(Color.white)
                            .frame(width: 30, height: 30)
                            .offset(x: 20, y: -30)
                            .opacity(opacity)
                    }
                    
                    Text("Beer Matcher")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 20)
                        .shadow(color: .white.opacity(0.3), radius: 10)
                    
                    Text("Find your perfect match")
                        .font(.system(size: 20))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.top, 8)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    // Main animation
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.9
                        self.opacity = 1.0
                        self.rotation = 30.0
                    }
                    
                    // Generate bubbles
                    generateBubbles()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
    
    private func generateBubbles() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        // Create initial bubbles
        for _ in 0...15 {
            let bubble = (
                id: UUID(),
                position: CGPoint(
                    x: CGFloat.random(in: 0...screenWidth),
                    y: CGFloat.random(in: screenHeight/2...screenHeight)
                ),
                size: CGFloat.random(in: 10...30)
            )
            bubbles.append(bubble)
        }
        
        // Animate bubbles
        withAnimation(
            .easeInOut(duration: 2.0)
            .repeatForever(autoreverses: false)
        ) {
            for i in 0..<bubbles.count {
                bubbles[i].position.y -= screenHeight * 1.5
            }
        }
    }
}