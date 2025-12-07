//
//  UIViewController+RootChange.swift
//  Moodify
//
//  Created by Kenan Memmedov on 04.12.25.
//
import UIKit

extension UIApplication {
    static var sceneDelegate: SceneDelegate? {
        return shared.connectedScenes
            .first { $0.activationState == .foregroundActive }?
            .delegate as? SceneDelegate
    }
}
