//
//  ImageLoader.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/23/24.
//

import Foundation
import UIKit

class ImageLoader {
    static func loadImage(fromPath path: String) -> UIImage {
        // Extract the filename from the path
        let filename = (path as NSString).lastPathComponent
        
        // Get the documents directory
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to access documents directory")
            return UIImage()
        }
        
        // Create the full URL
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        // Load and return the image
        return UIImage(contentsOfFile: fileURL.path) ?? UIImage(named: "julia") ?? UIImage()
    }
}


