//
//  PenSizeDrawerViewController.swift
//  customcontainers
//
//  Created by DS Mitchell on 11/24/18.
//  Copyright © 2018 The App Studio LLC. All rights reserved.
//

import UIKit

final class PenSizeDrawerViewController: UIViewController {
	
	// MARK: - Interface Builder outlets
	
	@IBOutlet var controlStackView: UIStackView!
	
	@IBInspectable var currentPenSize: CGFloat = 3 {
		didSet { updateCurrentPenSize(currentPenSize) }
	}
	
	// MARK: - UIViewController overrides
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let button = sender as? PenSelectorButton {
			currentPenSize = button.penSize
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		updateCurrentPenSize(currentPenSize)
	}
	
	// MARK: - Private methods
	
	private func updateCurrentPenSize(_ size: CGFloat) {
		guard isViewLoaded else { return }
		for button in controlStackView.arrangedSubviews.compactMap({ $0 as? PenSelectorButton }) {
			button.borderWidth = button.penSize == size ? 2.0 : 0.0
		}
	}
}
