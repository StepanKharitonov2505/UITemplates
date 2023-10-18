//
//  AdvancedGradientAnimationViewController.swift
//  MyTestApp
//
//  Created by  user on 06.10.2023.
//

import UIKit
import SnapKit

class AdvancedGradientAnimationViewController: UIViewController {

    private lazy var animatedMaskLabel = GradientMaskView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Private methods

private extension AdvancedGradientAnimationViewController {
    func setupUI() {
        self.view.backgroundColor = SingletonColorManager.shared.colorScheme.darkMainColor
        self.view.addSubview(animatedMaskLabel)
        setConstraint()
    }
    
    func setConstraint() {
        animatedMaskLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(self.view.snp.bottom).inset(50)
            make.left.equalTo(self.view.snp.left).offset(50)
            make.right.equalTo(self.view.snp.right).inset(50)
        }
    }
}
