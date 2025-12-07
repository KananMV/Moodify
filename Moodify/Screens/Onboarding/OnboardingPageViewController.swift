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
        return pagesData.enumerated().map { index, model in
            let vc = OnboardController()
            vc.model = model
            vc.pageIndex = index
            vc.totalCount = pagesData.count
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
            setViewControllers([first], direction: .forward, animated: false)
        }
    }
    
    func goToNextPage(currentVC: UIViewController) {
        guard let index = pages.firstIndex(of: currentVC) else { return }
        let nextIndex = index + 1
        
        if nextIndex < pages.count {
            let next = pages[nextIndex]
            UIView.transition(with: view,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: {
                self.setViewControllers([next],
                                        direction: .forward,
                                        animated: false)
            },
                              completion: nil)
            return
        }
        finishOnboarding()
    }
    
    private func finishOnboarding() {
        
        UIApplication.sceneDelegate?.changeRootToEntryFromOnboard()
        UserDefaultsManager.shared.saveDataBool(value: false, key: .isFirstTimeLaunch)
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
