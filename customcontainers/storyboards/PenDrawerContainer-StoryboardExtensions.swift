//
//  PenDrawerContainer-StoryboardExtensions.swift
//  customcontainers
//
//  Created by DS Mitchell on 11/24/18.
//  Copyright © 2018 The App Studio LLC. All rights reserved.
//

import UIKit

extension PenDrawerContainerViewController /* Interface Builder Actions */ {
	
	// IBActions do not have to go into extensions, but this is a way you can move
	// storyboard-specific details out of the ViewController code if it suits you.
	// In the case of this sample, it is a way to separate out interesting code
	// for the presentation.
	
	@IBAction private func eraserButtonTapped(_ sender: UIButton) {
		updateButtons(makeActive: sender)
		advertisePenChange(color: .clear, size: 18)
		// "close" the drawer by setting the active view controller to nil
		activeViewController = nil
	}
	
	@IBAction private func unwindToPenDrawerContainer(_ segue: UIStoryboardSegue) {
		// Switch on the ViewController that initiated the unwind. What is its current value?
		switch segue.source {
		case let penColorDrawerViewController as PenColorDrawerViewController:
			currentPenColor = penColorDrawerViewController.currentPenColor
		case let penSizeDrawerViewController as PenSizeDrawerViewController:
			currentPenSize = penSizeDrawerViewController.currentPenSize
		default:
			return // Nothing special to do with this segue
		}
		updateButtons(makeActive: penSizeButton)
		advertisePenChange(color: currentPenColor, size: currentPenSize)
		// and "close" the drawer by setting the active view controller to nil
		activeViewController = nil
	}
}

extension PenDrawerContainerViewController: SegueHandling {
	
	/// Segues defined in the UIStoryboard that we can invoke programmatically
	///
	/// - showSize: presents the Pen Size Drawer ViewController
	/// - showColor: presents the Pen Color Drawer ViewController
	internal enum SegueIdentifier: String {
		case showSize
		case showColor
	}
}
