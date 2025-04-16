//
//  SplashVC.swift
//  News
//
//  Created by Yunus Oktay on 19.02.2025.
//

import UIKit
import SnapKit
import Lottie

final class SplashVC: UIViewController {

    var onSplashCompleted: (() -> Void)?

    private func navigateToNewsVC() {
        onSplashCompleted?()
    }

    // MARK: - UI Components
    private lazy var animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "newsanimation")
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .playOnce
        animation.animationSpeed = 3
        return animation
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAnimation()
    }

    deinit {
        animationView.stop()
        print("SplashVC deallocated from memory")
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemGray
        configureAnimation()
    }

    private func configureAnimation() {
        view.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupAnimation() {
        animationView.play { [weak self] _ in
            self?.navigateVC()
        }
    }

    // MARK: - Navigation
    private func navigateVC() {
     onSplashCompleted?()

     if onSplashCompleted == nil {
         let tabbarVC = TabBarVC()
         // swiftlint:disable:next line_length
         guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else {
             return
         }
         window.rootViewController = tabbarVC

         UIView
             .transition(
                 with: window,
                 duration: 0.3,
                 options: .transitionCrossDissolve,
                 animations: nil,
                 completion: nil
             )
        }
    }

}
