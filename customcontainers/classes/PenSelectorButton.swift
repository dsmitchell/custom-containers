//
//  PenSelectorButton.swift
//  customcontainers
//
//  Created by DS Mitchell on 11/24/18.
//  Copyright © 2018 The App Studio LLC. All rights reserved.
//

import UIKit

@IBDesignable public final class PenSelectorButton: UIButton {
	
	// MARK: - Interface Builder properties
	
	@IBInspectable public var borderWidth: CGFloat = 2 {
		didSet { updateBorderWidth() }
	}
	
	@IBInspectable public var penColor: UIColor! {
		get {
			guard let color = penSelectorLayer.backgroundColor else { return nil }
			return UIColor(cgColor: color)
		}
		set { penSelectorLayer.backgroundColor = newValue.cgColor }
	}
	
	@IBInspectable public var penSize: CGFloat = 0 {
		didSet { updatePenSize() }
	}

	// MARK: - UIButton overrides
	
	public required init?(coder aDecoder: NSCoder) {
		// Used via storyboard during runtime
		super.init(coder: aDecoder)
		setupControl()
	}
	
	override public init(frame: CGRect) {
		// Used by Interface Builder during design-time
		super.init(frame: frame)
		setupControl()
	}
	
	override public func layoutSublayers(of layer: CALayer) {
		super.layoutSublayers(of: layer)
		let position = CGPoint(x: bounds.midX, y: bounds.midY)
		if penSize > 0 {
			let side = pow(penSize * 10, 0.6).rounded()
			penSelectorLayer.bounds = bounds.insetBy(dx: position.x - side, dy: position.y - side)
			penSelectorLayer.cornerRadius = side
		} else {
			let minSide = min(bounds.height, bounds.width)
			penSelectorLayer.bounds = CGRect(origin: .zero, size: CGSize(width: minSide, height: minSide))
			penSelectorLayer.cornerRadius = minSide / 2
		}
		penSelectorLayer.position = position
	}
	
	override public func tintColorDidChange() {
		super.tintColorDidChange()
		updateBorderColor()
	}
	
	// MARK: - Private properties and methods
	
	private let penSelectorLayer = CALayer()
	
	private func setupControl() {
		updateBorderColor()
		updateBorderWidth()
		layer.addSublayer(penSelectorLayer)
	}
	
	private func updateBorderColor() {
		penSelectorLayer.borderColor = tintColor.cgColor
	}
	
	private func updateBorderWidth() {
		penSelectorLayer.borderWidth = borderWidth
	}
	
	private func updatePenSize() {
		setNeedsLayout()
	}
}
