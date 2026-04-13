import SwiftUI

struct KeycapShapeView: View {
    let primaryColor: String
    let legendCharacter: String
    let rarity: Rarity
    let isCollected: Bool
    let size: CGFloat
    var widthUnit: CGFloat = 1.0

    // Clamp visual width: 1u=1x, modifiers slightly wider, wide keys wider, space capped
    private var visualScale: CGFloat {
        if widthUnit >= 5.0 { return 2.8 }        // Space
        if widthUnit >= 2.0 { return widthUnit }   // Wide keys: actual ratio
        return widthUnit                            // Standard + modifiers
    }

    private var displayWidth: CGFloat {
        size * visualScale
    }

    private var displayHeight: CGFloat {
        if widthUnit >= 5.0 { return size * 0.75 }  // Space: shorter
        return size
    }

    var body: some View {
        let baseColor = isCollected ? Color(hex: primaryColor) : Color.gray.opacity(0.25)
        let textColor = isCollected ? legendColor : Color.gray.opacity(0.4)

        ZStack {
            if isCollected { rarityGlow }

            Canvas { context, canvasSize in
                let w = canvasSize.width
                let h = canvasSize.height
                drawIsometric(context: context, w: w, h: h, baseColor: baseColor)
            }
            .frame(width: displayWidth, height: displayHeight)
            .overlay(
                Group {
                    if isCollected {
                        legendView(textColor: textColor)
                    } else {
                        Image(systemName: "lock.fill")
                            .font(.system(size: size * 0.16))
                            .foregroundColor(.gray.opacity(0.4))
                            .offset(y: -displayHeight * 0.18)
                    }
                }
            )
        }
    }

    // MARK: - Legend View

    @ViewBuilder
    private func legendView(textColor: Color) -> some View {
        let yOffset = -displayHeight * 0.18

        if legendCharacter == "BS" {
            // Backspace: icon + text
            VStack(spacing: 1) {
                Image(systemName: "delete.backward")
                    .font(.system(size: legendFontSize * 0.6))
                Text("Backspace")
                    .font(.system(size: legendFontSize * 0.35, weight: .medium))
            }
            .foregroundColor(textColor)
            .offset(y: yOffset)
        } else if legendCharacter == "Enter" {
            // Enter: ↵ symbol
            Image(systemName: "return")
                .font(.system(size: legendFontSize * 0.85))
                .foregroundColor(textColor)
                .offset(y: yOffset)
        } else if legendCharacter == "Tab" {
            Image(systemName: "arrow.right.to.line")
                .font(.system(size: legendFontSize * 0.8))
                .foregroundColor(textColor)
                .offset(y: yOffset)
        } else if legendCharacter == "Caps" {
            Image(systemName: "capslock")
                .font(.system(size: legendFontSize * 0.8))
                .foregroundColor(textColor)
                .offset(y: yOffset)
        } else if legendCharacter == "Shift" {
            Image(systemName: "shift")
                .font(.system(size: legendFontSize * 0.85))
                .foregroundColor(textColor)
                .offset(y: yOffset)
        } else if legendCharacter == "Ctrl" {
            Image(systemName: "control")
                .font(.system(size: legendFontSize * 0.8))
                .foregroundColor(textColor)
                .offset(y: yOffset)
        } else if legendCharacter == "Alt" {
            Image(systemName: "option")
                .font(.system(size: legendFontSize * 0.8))
                .foregroundColor(textColor)
                .offset(y: yOffset)
        } else if legendCharacter == "Cmd" {
            Image(systemName: "command")
                .font(.system(size: legendFontSize * 0.8))
                .foregroundColor(textColor)
                .offset(y: yOffset)
        } else if legendCharacter == "Fn" {
            Text("fn")
                .font(.system(size: legendFontSize * 0.7, weight: .bold))
                .foregroundColor(textColor)
                .offset(y: yOffset)
        } else if legendCharacter == "Space" {
            // Space: just a subtle line or empty
            Rectangle()
                .fill(textColor.opacity(0.3))
                .frame(width: displayWidth * 0.25, height: 1.5)
                .offset(y: yOffset)
        } else if legendCharacter == "Esc" {
            Text("Esc")
                .font(.system(size: legendFontSize * 0.7, weight: .bold))
                .foregroundColor(textColor)
                .offset(y: yOffset)
        } else {
            Text(legendCharacter)
                .font(.system(size: legendFontSize, weight: .bold, design: .monospaced))
                .foregroundColor(textColor)
                .offset(y: yOffset)
        }
    }

    // MARK: - Isometric Drawing (all keys)

    private func drawIsometric(context: GraphicsContext, w: CGFloat, h: CGFloat, baseColor: Color) {
        let cx = w / 2

        // Top face proportions - adjust for wider keys
        let topY = h * 0.08
        let topW: CGFloat
        let topH: CGFloat
        let topCenterY: CGFloat

        if widthUnit >= 5.0 {
            // Space: wide and flat top
            topW = w * 0.44
            topH = h * 0.20
            topCenterY = h * 0.30
        } else if widthUnit >= 2.0 {
            // Wide keys: wider top
            topW = w * 0.42
            topH = h * 0.22
            topCenterY = h * 0.28
        } else {
            // Standard/modifier
            topW = w * 0.38
            topH = h * 0.22
            topCenterY = h * 0.28
        }

        let topCenter = CGPoint(x: cx, y: topCenterY)

        let topFace = Path { p in
            p.move(to: CGPoint(x: cx, y: topY))
            p.addLine(to: CGPoint(x: cx + topW, y: topCenter.y))
            p.addLine(to: CGPoint(x: cx, y: topCenter.y + topH))
            p.addLine(to: CGPoint(x: cx - topW, y: topCenter.y))
            p.closeSubpath()
        }

        // Base - wider than top (tapered keycap)
        let baseBottomY = h * (widthUnit >= 5.0 ? 0.85 : 0.88)
        let baseSideY = h * (widthUnit >= 5.0 ? 0.58 : 0.56)
        let baseBottom = CGPoint(x: cx, y: baseBottomY)
        let baseLeft = CGPoint(x: w * 0.04, y: baseSideY)
        let baseRight = CGPoint(x: w * 0.96, y: baseSideY)

        let leftSide = Path { p in
            p.move(to: CGPoint(x: cx - topW, y: topCenter.y))
            p.addLine(to: CGPoint(x: cx, y: topCenter.y + topH))
            p.addLine(to: baseBottom)
            p.addLine(to: baseLeft)
            p.closeSubpath()
        }

        let rightSide = Path { p in
            p.move(to: CGPoint(x: cx + topW, y: topCenter.y))
            p.addLine(to: CGPoint(x: cx, y: topCenter.y + topH))
            p.addLine(to: baseBottom)
            p.addLine(to: baseRight)
            p.closeSubpath()
        }

        // Fill
        context.fill(leftSide, with: .color(darken(baseColor, by: 0.25)))
        context.fill(rightSide, with: .color(darken(baseColor, by: 0.12)))
        context.fill(topFace, with: .color(baseColor))

        // Dish
        let dishInset: CGFloat = 0.30
        let dishW = topW * (1 - dishInset)
        let dishH = topH * (1 - dishInset)
        let dish = Path { p in
            p.move(to: CGPoint(x: cx, y: topCenter.y - dishH))
            p.addLine(to: CGPoint(x: cx + dishW, y: topCenter.y))
            p.addLine(to: CGPoint(x: cx, y: topCenter.y + dishH))
            p.addLine(to: CGPoint(x: cx - dishW, y: topCenter.y))
            p.closeSubpath()
        }
        context.fill(dish, with: .color(darken(baseColor, by: 0.06)))

        // Outlines
        let ow = rarityOutlineWidth
        let oc = isCollected ? rarityOutlineColor : .gray.opacity(0.25)
        context.stroke(topFace, with: .color(oc), lineWidth: ow)
        context.stroke(leftSide, with: .color(oc), lineWidth: ow)
        context.stroke(rightSide, with: .color(oc), lineWidth: ow)

        // Highlights
        if isCollected {
            let hl = highlightAlpha
            let hlPath1 = Path { p in
                p.move(to: CGPoint(x: cx, y: topY))
                p.addLine(to: CGPoint(x: cx + topW, y: topCenter.y))
            }
            let hlPath2 = Path { p in
                p.move(to: CGPoint(x: cx, y: topY))
                p.addLine(to: CGPoint(x: cx - topW, y: topCenter.y))
            }
            context.stroke(hlPath1, with: .color(.white.opacity(hl)), lineWidth: highlightWidth)
            context.stroke(hlPath2, with: .color(.white.opacity(hl * 0.7)), lineWidth: highlightWidth)

            if rarity >= .epic {
                let shine = Path { p in
                    p.move(to: CGPoint(x: cx, y: topCenter.y - dishH * 0.5))
                    p.addLine(to: CGPoint(x: cx + dishW * 0.5, y: topCenter.y))
                }
                context.stroke(shine, with: .color(.white.opacity(0.5)), lineWidth: 1.5)
            }
        }
    }

    // MARK: - Legend sizing

    private var legendFontSize: CGFloat {
        if widthUnit >= 5.0 { return size * 0.14 }
        if widthUnit >= 2.0 { return size * 0.17 }
        if widthUnit > 1.0 { return size * 0.19 }
        return size * 0.22
    }

    // MARK: - Rarity Effects

    @ViewBuilder
    private var rarityGlow: some View {
        switch rarity {
        case .common:
            EmptyView()
        case .uncommon:
            RoundedRectangle(cornerRadius: 8)
                .fill(rarity.color.opacity(0.08))
                .frame(width: displayWidth * 0.9, height: displayHeight * 0.9)
                .blur(radius: 4)
        case .rare:
            RoundedRectangle(cornerRadius: 8)
                .fill(rarity.color.opacity(0.15))
                .frame(width: displayWidth * 0.9, height: displayHeight * 0.9)
                .blur(radius: 6)
        case .epic:
            RoundedRectangle(cornerRadius: 8)
                .fill(rarity.color.opacity(0.25))
                .frame(width: displayWidth * 0.95, height: displayHeight * 0.95)
                .blur(radius: 10)
        case .legendary:
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.orange.opacity(0.3))
                .frame(width: displayWidth, height: displayHeight)
                .blur(radius: 14)
        case .eternal:
            TimelineView(.animation) { timeline in
                let t = timeline.date.timeIntervalSinceReferenceDate
                let hue = t.truncatingRemainder(dividingBy: 3.0) / 3.0
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(hue: hue, saturation: 0.6, brightness: 1.0).opacity(0.35))
                    .frame(width: displayWidth, height: displayHeight)
                    .blur(radius: 16)
            }
        }
    }

    private var rarityOutlineWidth: CGFloat {
        switch rarity {
        case .common: return 1.0
        case .uncommon: return 1.5
        case .rare: return 2.0
        case .epic: return 2.5
        case .legendary, .eternal: return 3.0
        }
    }

    private var rarityOutlineColor: Color {
        switch rarity {
        case .common: return .black.opacity(0.3)
        case .uncommon: return rarity.color.opacity(0.5)
        case .rare: return rarity.color.opacity(0.6)
        case .epic: return rarity.color.opacity(0.7)
        case .legendary: return Color.orange.opacity(0.8)
        case .eternal: return .purple.opacity(0.8)
        }
    }

    private var highlightAlpha: Double {
        switch rarity {
        case .common: return 0.15
        case .uncommon: return 0.35
        case .rare: return 0.45
        case .epic: return 0.55
        case .legendary: return 0.65
        case .eternal: return 0.7
        }
    }

    private var highlightWidth: CGFloat {
        switch rarity {
        case .common, .uncommon: return 1.5
        case .rare: return 2.0
        case .epic: return 2.5
        case .legendary, .eternal: return 3.0
        }
    }

    // MARK: - Helpers

    private var legendColor: Color {
        let hex = primaryColor.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255.0
        let g = Double((int >> 8) & 0xFF) / 255.0
        let b = Double(int & 0xFF) / 255.0
        let luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return luminance > 0.5 ? .black.opacity(0.7) : .white.opacity(0.9)
    }

    private func darken(_ color: Color, by amount: CGFloat) -> Color {
        return color.opacity(1.0 - Double(amount) * 0.5)
    }
}
