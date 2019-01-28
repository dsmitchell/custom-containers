//
//  PenColorDrawerViewController.swift
//  customcontainers
//
//  Created by DS Mitchell on 11/24/18.
//  Copyright © 2018 The App Studio LLC. All rights reserved.
//

import UIKit

final class PenColorDrawerViewController: UIViewController {
	
	// MARK: - Interface Builder outlets
	
	@IBOutlet weak var controlStackView: UIStackView!
	
	@IBInspectable var currentPenColor: UIColor! {
		didSet { updateCurrentPenColor(currentPenColor) }
	}
	
	// MARK: - UIViewController overrides
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let button = sender as? PenSelectorButton, let color = button.penColor {
			currentPenColor = color
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		updateCurrentPenColor(currentPenColor)
    }
	
	// MARK: - Private methods
	
	private func updateCurrentPenColor(_ color: UIColor) {
		guard isViewLoaded else { return }
		for button in controlStackView.arrangedSubviews.compactMap({ $0 as? PenSelectorButton }) {
			button.borderWidth = button.penColor == color ? 2.0 : 0.0
		}
	}
}
