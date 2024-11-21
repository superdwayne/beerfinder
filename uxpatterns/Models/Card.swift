import Foundation
import SceneKit
import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let title: String
    let content: String
    let gridPosition: GridPosition
    let imageName: String
    var selectionTime: Date?
    var isMatched: Bool = false
}

struct GridPosition: Equatable, Hashable {
    let row: Int
    let col: Int
} 
