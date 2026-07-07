//
//  UIApplication+Settings.swift
//  Drape
//
//  Created by Moaz on 06/07/2026.
//

import Foundation

//
//  UIApplication+Settings.swift
//  Drape
//
//  Created by Moaz on 06/07/2026.
//
import UIKit

func openAppSettings() {
    guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
    if UIApplication.shared.canOpenURL(settingsURL) {
        UIApplication.shared.open(settingsURL)
    }
}
