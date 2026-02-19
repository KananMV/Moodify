//
//  NetworkMonitor.swift
//  Moodify
//
//  Created by Kenan Memmedov on 29.01.26.
//

import Alamofire
import UIKit

final class NetworkMonitor {

    static let shared = NetworkMonitor()
    private let reachability = NetworkReachabilityManager()
    private var isAlertShowing = false

    private init() {}

    func start() {
        reachability?.startListening { [weak self] status in
            guard let self = self else { return }
            switch status {
            case .notReachable, .unknown:
                self.showAlertSpam()
            case .reachable:
                self.isAlertShowing = false
            }
        }
    }

    private func showAlertSpam() {
        DispatchQueue.main.async {
            guard !self.isAlertShowing,
                  let topVC = UIApplication.shared
                      .connectedScenes
                      .compactMap({ $0 as? UIWindowScene })
                      .first?
                      .windows
                      .first?
                      .rootViewController else { return }

            self.isAlertShowing = true

            let alert = UIAlertController(
                title: "No internet connection",
                message: "Please check your internet connection",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.isAlertShowing = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                    guard let self = self else { return }
                    if self.reachability?.isReachable == false {
                        self.showAlertSpam()
                    }
                }
            }))

            topVC.present(alert, animated: true)
        }
    }
}
