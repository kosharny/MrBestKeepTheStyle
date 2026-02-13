import SwiftUI

struct CustomTabShapeMB: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.closeSubpath()
        }
    }
}

// Better implementation purely for the cutout
struct TabBarCurveShape: Shape {
    var centerX: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let center = rect.width * 0.5
        let buttonRadius: CGFloat = 34 // Slightly larger than button (60pt + gap)
        let capsuleHeight: CGFloat = 60 // Main capsule height
        let capsuleRadius: CGFloat = capsuleHeight / 2 // Perfect semicircles
        
        return Path { path in
            // Start from left side at middle of capsule
            path.move(to: CGPoint(x: 0, y: capsuleRadius))
            
            // Left semicircle (capsule end)
            path.addArc(
                center: CGPoint(x: capsuleRadius, y: capsuleRadius),
                radius: capsuleRadius,
                startAngle: .degrees(180),
                endAngle: .degrees(270),
                clockwise: false
            )
            
            // Top line to start of button bump
            path.addLine(to: CGPoint(x: center - buttonRadius, y: 0))
            
            // Circular bump for button (going UP, then back down)
            path.addArc(
                center: CGPoint(x: center, y: 0),
                radius: buttonRadius,
                startAngle: .degrees(180),
                endAngle: .degrees(0),
                clockwise: true // Changed to true for upward bump
            )
            
            // Continue top line to right
            path.addLine(to: CGPoint(x: rect.width - capsuleRadius, y: 0))
            
            // Right semicircle (capsule end)
            path.addArc(
                center: CGPoint(x: rect.width - capsuleRadius, y: capsuleRadius),
                radius: capsuleRadius,
                startAngle: .degrees(270),
                endAngle: .degrees(90),
                clockwise: false
            )
            
            // Bottom line
            path.addLine(to: CGPoint(x: capsuleRadius, y: capsuleHeight))
            
            // Bottom left semicircle
            path.addArc(
                center: CGPoint(x: capsuleRadius, y: capsuleRadius),
                radius: capsuleRadius,
                startAngle: .degrees(90),
                endAngle: .degrees(180),
                clockwise: false
            )
            
            path.closeSubpath()
        }
    }
}
