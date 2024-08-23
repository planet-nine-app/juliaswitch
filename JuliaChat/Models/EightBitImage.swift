//
//  EightBitImage.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/22/24.
//

import Foundation
import UIKit

struct EightBitImage {
    let originalImagePath: String
    var filePath: String?
    var image: UIImage?
    private var snesColors: [ESColor]!
    private var nesColors: [String: [ESColor]]!
    
    func pixelate(pixels: UnsafeMutablePointer<UInt32>, width: Int, x: Int, y: Int, size: Int) -> (Int, Int, Int) {
        var rs: [CGFloat] = []
        var gs: [CGFloat] = []
        var bs: [CGFloat] = []
        
        for dy in 0..<size {
            for dx in 0..<size {
                let index = (y + dy) * width + (x + dx)
                //print(index)
                let pixel = pixels[index]
                rs.append(CGFloat((pixel >> 16) & 0xFF) / 255.0)
                gs.append(CGFloat((pixel >> 8) & 0xFF) / 255.0)
                bs.append(CGFloat(pixel & 0xFF) / 255.0)
            }
        }
        
        let redAverage = Int(rs.reduce(0, +) / CGFloat(rs.count) * 255)
        let greenAverage = Int(gs.reduce(0, +) / CGFloat(gs.count) * 255)
        let blueAverage = Int(bs.reduce(0, +) / CGFloat(bs.count) * 255)
        
        return (redAverage, greenAverage, blueAverage)
    }

    func snesate(pixels: (Int, Int, Int)) -> UInt32 {
        let (r, g, b) = pixels
        
        let closestSNESColor = snesColors.min(by: { color1, color2 in
            let distance1 = pow(Double(color1.red) - Double(r), 2) +
                            pow(Double(color1.green) - Double(g), 2) +
                            pow(Double(color1.blue) - Double(b), 2)
            let distance2 = pow(Double(color2.red) - Double(r), 2) +
                            pow(Double(color2.green) - Double(g), 2) +
                            pow(Double(color2.blue) - Double(b), 2)
            return distance1 < distance2
        })!
        
        return 0xFF000000 | // Alpha
               (UInt32(closestSNESColor.red) << 16) |
               (UInt32(closestSNESColor.green) << 8) |
               UInt32(closestSNESColor.blue)
    }
    
    func nesate(pixels: (Int, Int, Int)) -> UInt32 {
        let (r, g, b) = pixels
        
        var colorsToChooseFrom: [ESColor]?
        
        if r >= g && g >= b {
            colorsToChooseFrom = nesColors["red"]
        }
        if g >= r && g >= b {
            colorsToChooseFrom = nesColors["green"]
        }
        if b >= r && b >= g {
            colorsToChooseFrom = nesColors["blue"]
        }
        if abs(r - g) < 20 && abs(r - b) < 20 {
            colorsToChooseFrom = nesColors["gray"]
        }
        
        guard let colorsToChooseFrom = colorsToChooseFrom else { return UInt32(123444) }
        
        let closestNESColor = colorsToChooseFrom.min(by: { color1, color2 in
            let distance1 = pow(Double(color1.red) - Double(r), 2) +
                            pow(Double(color1.green) - Double(g), 2) +
                            pow(Double(color1.blue) - Double(b), 2)
            let distance2 = pow(Double(color2.red) - Double(r), 2) +
                            pow(Double(color2.green) - Double(g), 2) +
                            pow(Double(color2.blue) - Double(b), 2)
            return distance1 < distance2
        }) ?? colorsToChooseFrom[0]
        
        return 0xFF000000 | // Alpha
               (UInt32(closestNESColor.red) << 16) |
               (UInt32(closestNESColor.green) << 8) |
               UInt32(closestNESColor.blue)
    }

    func processImage(pixelData: UnsafeMutablePointer<UInt32>, width: Int, height: Int, imageWidth: Int, imageHeight: Int) {
        let count = width * height
        let size = 4
        for y in stride(from: 0, to: height, by: size) {
            for x in stride(from: 0, to: width, by: size) {
                let averageColor = pixelate(pixels: pixelData, width: imageWidth, x: x, y: y, size: size)
                //let esColor = snesate(pixels: averageColor)
                let esColor = nesate(pixels: averageColor)
                
                for dy in 0..<size {
                    for dx in 0..<size {
                        let index = (y + dy) * imageWidth + (x + dx)
                        if index < count {
                            pixelData[index] = esColor
                        }
                    }
                }
            }
        }
    }
    
    func generateSNESColors() -> [ESColor] {
        var colors: [ESColor] = []
        colors.reserveCapacity(32 * 32 * 32)  // Pre-allocate capacity for efficiency
        
        for r in 0..<32 {
            for g in 0..<32 {
                for b in 0..<32 {
                    let color = ESColor(
                        red: UInt8((r * 255) / 31),
                        green: UInt8((g * 255) / 31),
                        blue: UInt8((b * 255) / 31)
                    )
                    colors.append(color)
                }
            }
        }
        
        return colors
    }
    
    func hexToRGB(hex: String) -> ESColor? {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }
        
        let red = UInt8((rgb & 0xFF0000) >> 16)
        let green = UInt8((rgb & 0x00FF00) >> 8)
        let blue = UInt8(rgb & 0x0000FF)
        
        return ESColor(red: red, green: green, blue: blue)
    }
    
    func generateNESColors() -> [String: [ESColor]] {
        let hexCodes = [
            "#000000",
            "#fcfcfc",
            "#f8f8f8",
            "#bcbcbc",
            "#7c7c7c",
            "#a4e4fc",
            "#3cbcfc",
            "#0078f8",
            "#0000fc",
            "#b8b8f8",
            "#6888fc",
            "#0058f8",
            "#0000bc",
            "#d8b8f8",
            "#9878f8",
            "#6844fc",
            "#4428bc",
            "#f8b8f8",
            "#f878f8",
            "#d800cc",
            "#940084",
            "#f8a4c0",
            "#f85898",
            "#e40058",
            "#a80020",
            "#f0d0b0",
            "#f87858",
            "#f83800",
            "#a81000",
            "#fce0a8",
            "#fca044",
            "#e45c10",
            "#881400",
            "#f8d878",
            "#f8b800",
            "#ac7c00",
            "#503000",
            "#d8f878",
            "#b8f818",
            "#00b800",
            "#007800",
            "#b8f8b8",
            "#58d854",
            "#00a800",
            "#006800",
            "#b8f8d8",
            "#58f898",
            "#00a844",
            "#005800",
            "#00fcfc",
            "#00e8d8",
            "#008888",
            "#004058",
            "#f8d8f8",
            "#787878"
            ]
        
        var colors = [String: [ESColor]]()
        colors["gray"] = [ESColor]()
        colors["red"] = [ESColor]()
        colors["green"] = [ESColor]()
        colors["blue"] = [ESColor]()
        
        for hexCode in hexCodes {
            if let rgb = hexToRGB(hex: hexCode) {
                switch rgb.mainColor {
                case "gray": colors["gray"]?.append(rgb)
                    break
                case "red": colors["red"]?.append(rgb)
                    break
                case "green": colors["green"]?.append(rgb)
                    break
                default: colors["blue"]?.append(rgb)
                }
            }
        }
        
        return colors
    }
    
    func modifyImage() -> UIImage? {
        //snesColors = generateSNESColors()
        guard let cgImage = image?.cgImage else { return nil }
        
        let width = cgImage.width
        let height = cgImage.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        
        guard let context = CGContext(data: nil,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: 0,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo) else { return nil }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let data = context.data else { return nil }
        print("here")
        
        let pixelData = data.bindMemory(to: UInt32.self, capacity: width * height)
        
        // Usage example:
//        let testWidth = 100
//        let testHeight = 100
        let testWidth = width
        let testHeight = height
       

        // Fill pixelData with your image data here
        print(pixelData[100])

        processImage(pixelData: pixelData, width: testWidth, height: testHeight, imageWidth: width, imageHeight: height)
        
        print(pixelData[100])
        
        // Create a new context with the modified data
        let bitsPerComponent = 8
        let bytesPerRow = testWidth * 4 // 4 bytes per pixel (RGBA)
        let colorSpace2 = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo2 = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue

        guard let newContext = CGContext(data: pixelData,
                                         width: width,
                                         height: height,
                                         bitsPerComponent: bitsPerComponent,
                                         bytesPerRow: bytesPerRow,
                                         space: colorSpace2,
                                         bitmapInfo: bitmapInfo2) else {
            print("Failed to create new context")
            return nil
        }
        
        if let modifiedCGImage = newContext.makeImage() {
            print("setting modified image")
            let modifiedImage = UIImage(cgImage: modifiedCGImage)
            return modifiedImage
        } else {
            return image
        }
    }
    
    mutating func saveImage() {
        guard let image = image else { return }
            
        let imageName = UUID().uuidString
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(imageName).jpg")
        filePath = fileURL.path
            
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            do {
                try jpegData.write(to: fileURL)
                print("Image saved successfully at: \(filePath)")
            } catch {
                print("Failed to save image: \(error)")
            }
        }
    }
    
    init(originalImagePath: String, image: UIImage?) {
        self.originalImagePath = originalImagePath
        if let image = image {
            self.image = image
        } else {
            self.image = UIImage(contentsOfFile: self.originalImagePath)
        }
        self.nesColors = generateNESColors()
        self.image = modifyImage()
    }
}
