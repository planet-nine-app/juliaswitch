//
//  PreferencesModel.swift
//  JuliaChat
//
//  Created by Zach Babb on 8/13/24.
//

import Foundation
import SwiftData

@Model()
class Preferences {
    var appPreferences = [String: String]()
    var globalPreferences = [String: String]()
    
    init(appPreferences: [String : String] = [String: String](), globalPreferences: [String : String] = [String: String]()) {
        self.appPreferences = appPreferences
        self.globalPreferences = globalPreferences
    }
    
    enum ConfigKeys: String, CodingKey {
        case appPreferences
        case globalPreferences
    }
}
