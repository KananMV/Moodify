//
//  Cordinator.swift
//  MovieApp
//
//  Created by Kenan Memmedov 
//

import UIKit

protocol Cordinator {
    var navigation: UINavigationController { get }
    func start()
}
