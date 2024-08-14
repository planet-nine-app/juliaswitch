//
//  ImagePickerView.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/12/24.
//

import SwiftUI

struct SNESColor {
    let red: UInt8
    let green: UInt8
    let blue: UInt8
    
    var uiColor: Color {
        Color(red: Double(red) / 255.0, green: Double(green) / 255.0, blue: Double(blue) / 255.0)
    }
    
    var hexString: String {
        String(format: "#%02X%02X%02X", red, green, blue)
    }
}

struct ImagePickerView: View {
    @State private var selectedImage: UIImage?
    @State private var modifiedImage: UIImage?
    @State private var isImagePickerPresented = false

    var body: some View {
        VStack {
            if let image = modifiedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Text("No image selected")
            }
            
            Button("Select Image") {
                isImagePickerPresented = true
            }
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $selectedImage, completion: modifyImage)
        }
    }
    
    func modifyImage() {
        guard let image = selectedImage,
              let cgImage = image.cgImage else { return }
        
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
                                      bitmapInfo: bitmapInfo) else { return }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let data = context.data else { return }
        print("here")
        
        let pixelData = data.bindMemory(to: UInt32.self, capacity: width * height)
        
        // Generate all 32,768 colors
        for r in 0..<32 {
            for g in 0..<32 {
                for b in 0..<32 {
                    SNESColor(
                        red: UInt8((r * 255) / 31),
                        green: UInt8((g * 255) / 31),
                        blue: UInt8((b * 255) / 31)
                    )
                }
            }
        }
        
        func pixelate(pixels: Data, pixelCount: Int) -> Data {
            var rs = [CGFloat]()
            var gs = [CGFloat]()
            var bs = [CGFloat]()
            
            for index in 0..<pixelCount {
                rs.append(CGFloat(pixels[index]) / 255.0)
                gs.append(CGFloat(pixels[index]) / 255.0)
                bs.append(CGFloat(pixels[index]) / 255.0)
            }
            
            var redAverage = rs.reduce(0) { current, next in
                return current + next
            }
            var greenAverage = gs.reduce(0) { current, next in
                return current + next
            }
            var blueAverage = bs.reduce(0) { current, next in
                return current + next
            }
            
            let redAverageInt = Int(redAverage) / pixelCount
            let greenAverageInt = Int(greenAverage) / pixelCount
            let blueAverageInt = Int(blueAverage) / pixelCount
            
            return Data()
        }
        
        func snesate(pixels: Data) -> Data {
            return Data()
        }
        /*let snesColors: [SNESColor] = (0..<32).flatMap { r in
            (0..<32).flatMap { g in
                (0..<32).map { b in
                    SNESColor(
                        red: UInt8((r * 255) / 31),
                        green: UInt8((g * 255) / 31),
                        blue: UInt8((b * 255) / 31)
                    )
                }
            }
        }*/
        
        // Create a 4x4 green square in the top-left corner
        for y in 0..<400 {
            for x in 0..<400 {
                let offset = y * width + x
                let color = pixelData[offset]
                pixelData[offset] = 0xFF00FF00  // ARGB for green
            }
        }
        print("after for")
        
        if let modifiedCGImage = context.makeImage() {
            print("setting modified image")
            modifiedImage = UIImage(cgImage: modifiedCGImage)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var completion: () -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
                parent.completion()
            }
            
            picker.dismiss(animated: true)
        }
    }
}
