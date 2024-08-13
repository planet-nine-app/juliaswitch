//
//  ImagePickerView.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/12/24.
//

import SwiftUI

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
        
        // Create a 4x4 green square in the top-left corner
        for y in 0..<100 {
            for x in 0..<100 {
                let offset = y * width + x
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
