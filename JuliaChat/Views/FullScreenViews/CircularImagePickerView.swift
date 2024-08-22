//
//  CircularImagePickerView.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/22/24.
//

import SwiftUI
import UIKit

struct CircularImagePicker: View {
    @State var selectedImage: UIImage?
    @State private var showImagePicker = false
    
    let circleSize: CGFloat = 200 // Adjust this to change the size of the circle
    
    var body: some View {
        VStack {
            ZStack {
                if let image = EightBitImage(originalImagePath: "", image: selectedImage).image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: circleSize, height: circleSize)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: circleSize, height: circleSize)
                    
                    Image(systemName: "camera")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                }
            }
            .overlay(
                Circle()
                    .stroke(Color.blue, lineWidth: 4)
            )
            .onTapGesture {
                showImagePicker = true
            }
            
            Text("Tap to select image")
                .foregroundColor(.blue)
                .padding(.top)
        }
        .sheet(isPresented: $showImagePicker) {
            UICircularImagePicker(image: $selectedImage)
        }
    }
}

struct UICircularImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<UICircularImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<UICircularImagePicker>) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: UICircularImagePicker
        
        init(_ parent: UICircularImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

