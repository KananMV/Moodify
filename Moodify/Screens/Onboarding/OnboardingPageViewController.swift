//
//  OnboardingPageViewController.swift
//  Moodify
//
//  Created by Kenan Memmedov on 25.11.25.
//

import UIKit

class OnboardingPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    let pagesData = [
        OnboardingModel(title: "Scan your mood", description: "Moodify uses advanced AI to understand your emotions and create personalized playlists."),
        OnboardingModel(title: "AI-Generated Playlists", description: "Moodify uses advanced AI to curate playlists that perfectly match your current emotional state. Experience music tailored to you."),
        OnboardingModel(title: "Music that resonates with your soul", description: "Moodify understands your emotions and curates playlists that truly connect with your inner self.")
    ]
    
    lazy var pages: [UIViewController] = {
        return pagesData.map { model in
            let vc = OnboardController()
            vc.model = model
            vc.onNext = { [weak self] in
                guard let self else { return }
                
                self.goToNextPage(currentVC: vc)
            }
            
            return vc
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true)
        }
    }
    
    func goToNextPage(currentVC: UIViewController) {
        guard let index = pages.firstIndex(of: currentVC) else { return }
        let nextIndex = index + 1
        guard nextIndex < pages.count else { return }
        let next = pages[nextIndex]
        setViewControllers([next], direction: .forward, animated: true)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = pages.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        
        return pages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else {
            return nil
        }
        
        return pages[index + 1]
    }
    
    
    
}
