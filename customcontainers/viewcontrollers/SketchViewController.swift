//
//  SketchViewController.swift
//  customcontainers
//
//  Created by DS Mitchell on 11/24/18.
//  Copyright © 2018 The App Studio LLC. All rights reserved.
//

import UIKit

final class SketchViewController: UIViewController {
	
	// MARK: - Interface Builder outlets
	
	@IBOutlet private weak var canvasView: CanvasView! {
		didSet { updateCanvasView() }
	}
	@IBOutlet private weak var penDrawerHeightConstraint: NSLayoutConstraint!
	
	// MARK: - UIViewController overrides
	
	override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
		guard container is PenDrawerContainerViewController else { return }
		penDrawerHeightConstraint.constant = container.preferredContentSize.height
		view.layoutIfNeeded() // This can happen inside an animation block
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		switch segue.destination {
		case let penDrawerViewController as PenDrawerContainerViewController:
			self.penDrawerViewController = penDrawerViewController
		default: break
		}
	}
	
	// MARK: - Interact with Apple CanvasView sample code
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard touches.contains(where: { $0.view === canvasView }) else {
			super.touchesBegan(touches, with: event)
			return
		}
		penDrawerViewController?.closeDrawer()
		canvasView.drawTouches(touches: touches, withEvent: event)
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard touches.contains(where: { $0.view === canvasView }) else {
			super.touchesMoved(touches, with: event)
			return
		}
		canvasView.drawTouches(touches: touches, withEvent: event)
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard touches.contains(where: { $0.view === canvasView }) else {
			super.touchesEnded(touches, with: event)
			return
		}
		canvasView.drawTouches(touches: touches, withEvent: event)
		canvasView.endTouches(touches: touches, cancel: false)
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard touches.contains(where: { $0.view === canvasView }) else {
			super.touchesCancelled(touches, with: event)
			return
		}
		canvasView.endTouches(touches: touches, cancel: true)
	}
	
	override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
		guard touches.contains(where: { $0.view === canvasView }) else {
			super.touchesEstimatedPropertiesUpdated(touches)
			return
		}
		canvasView.updateEstimatedPropertiesForTouches(touches: touches)
	}
	
	// MARK: - Private properties and methods
	
	private var penDrawerViewController: PenDrawerContainerViewController! {
		willSet { penDrawerViewController?.delegate = nil }
		didSet {
			penDrawerViewController?.delegate = self
			updateCanvasView()
		}
	}
	
	private func updateCanvasView() {
		guard canvasView != nil, penDrawerViewController != nil else { return }
		canvasView.currentColor = penDrawerViewController.currentPenColor
		canvasView.currentWidth = penDrawerViewController.currentPenSize
	}
}

extension SketchViewController: PenDrawerContainerViewControllerDelegate {
	
	func penDrawerContainer(_ viewController: PenDrawerContainerViewController, changedPenColor penColor: UIColor, penSize: CGFloat) {
		canvasView.flush()
		canvasView.currentColor = penColor
		canvasView.currentWidth = penSize
	}
}
