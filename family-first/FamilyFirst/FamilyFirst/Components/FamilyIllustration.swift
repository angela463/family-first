import SwiftUI

/// Three-person family mark from the Welcome mockup's inline SVG.
struct FamilyIllustration: Shape {
    func path(in rect: CGRect) -> Path {
        let scale = min(rect.width / 160, rect.height / 112)
        let origin = CGPoint(
            x: rect.midX - 80 * scale,
            y: rect.midY - 56 * scale
        )
        func point(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
            CGPoint(x: origin.x + x * scale, y: origin.y + y * scale)
        }

        var path = Path()
        path.addEllipse(in: CGRect(x: point(28, 18).x, y: point(28, 18).y, width: 24 * scale, height: 24 * scale))
        path.addEllipse(in: CGRect(x: point(66, 6).x, y: point(66, 6).y, width: 28 * scale, height: 28 * scale))
        path.addEllipse(in: CGRect(x: point(108, 18).x, y: point(108, 18).y, width: 24 * scale, height: 24 * scale))

        addBody(&path, from: point(20, 104), shoulder: point(20, 76), end: point(60, 76), foot: point(60, 104), rx: 20 * scale, ry: 22 * scale)
        addBody(&path, from: point(56, 104), shoulder: point(56, 70), end: point(104, 70), foot: point(104, 104), rx: 24 * scale, ry: 26 * scale)
        addBody(&path, from: point(100, 104), shoulder: point(100, 76), end: point(140, 76), foot: point(140, 104), rx: 20 * scale, ry: 22 * scale)
        return path
    }

    private func addBody(
        _ path: inout Path,
        from start: CGPoint,
        shoulder: CGPoint,
        end: CGPoint,
        foot: CGPoint,
        rx: CGFloat,
        ry: CGFloat
    ) {
        path.move(to: start)
        path.addLine(to: shoulder)
        addSVGArc(to: &path, from: shoulder, rx: rx, ry: ry, largeArc: false, sweep: true, end: end)
        path.addLine(to: foot)
    }
}

struct FamilyMark: View {
    var body: some View {
        FamilyIllustration()
            .stroke(Theme.forest, style: StrokeStyle(lineWidth: 7, lineCap: .round, lineJoin: .round))
            .frame(width: 190, height: 132)
            .accessibilityLabel("Family of three")
    }
}

private func addSVGArc(
    to path: inout Path,
    from start: CGPoint,
    rx rxIn: CGFloat,
    ry ryIn: CGFloat,
    largeArc: Bool,
    sweep: Bool,
    end: CGPoint
) {
    var rx = abs(rxIn)
    var ry = abs(ryIn)
    let dx = (start.x - end.x) / 2
    let dy = (start.y - end.y) / 2
    var rxsq = rx * rx
    var rysq = ry * ry
    let x1psq = dx * dx
    let y1psq = dy * dy
    let lambda = x1psq / rxsq + y1psq / rysq
    if lambda > 1 {
        let scale = sqrt(lambda)
        rx *= scale
        ry *= scale
        rxsq = rx * rx
        rysq = ry * ry
    }
    let sign: CGFloat = (largeArc == sweep) ? -1 : 1
    let numerator = max(0, rxsq * rysq - rxsq * y1psq - rysq * x1psq)
    let denominator = rxsq * y1psq + rysq * x1psq
    let coefficient = sign * sqrt(denominator == 0 ? 0 : numerator / denominator)
    let cxp = coefficient * rx * dy / ry
    let cyp = coefficient * -ry * dx / rx
    let center = CGPoint(x: cxp + (start.x + end.x) / 2, y: cyp + (start.y + end.y) / 2)

    func vectorAngle(_ ux: CGFloat, _ uy: CGFloat, _ vx: CGFloat, _ vy: CGFloat) -> CGFloat {
        let dot = ux * vx + uy * vy
        let lengths = sqrt(ux * ux + uy * uy) * sqrt(vx * vx + vy * vy)
        guard lengths > 0 else { return 0 }
        var angle = acos(min(1, max(-1, dot / lengths)))
        if ux * vy - uy * vx < 0 { angle = -angle }
        return angle
    }

    let startAngle = vectorAngle(1, 0, (dx - cxp) / rx, (dy - cyp) / ry)
    var delta = vectorAngle((dx - cxp) / rx, (dy - cyp) / ry, (-dx - cxp) / rx, (-dy - cyp) / ry)
    if !sweep && delta > 0 { delta -= 2 * .pi }
    if sweep && delta < 0 { delta += 2 * .pi }

    let steps = max(12, Int(abs(delta) / (.pi / 16)))
    for step in 1...steps {
        let angle = startAngle + delta * CGFloat(step) / CGFloat(steps)
        path.addLine(to: CGPoint(x: center.x + rx * cos(angle), y: center.y + ry * sin(angle)))
    }
}
