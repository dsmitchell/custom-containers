//
//  SegueHandling.swift
//  customcontainers
//
//  Created by DS Mitchell on 11/24/18.
//  Copyright © 2018 The App Studio LLC. All rights reserved.
//

import UIKit

/// Represents a storyboard segue handler
public protocol SegueHandling {
	
	/// A RawRepresentable type that represents a storyboard segue's identifier(s) (e.g. a String-based enum)
	associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandling where Self: UIViewController, SegueIdentifier.RawValue == String {
	
	/// Performs a segue using a SegueHandling.SegueIdentifier
	///
	/// - Parameters:
	///   - identifier: The UIStoryboardSegue's identifier
	///   - sender: The initiating sender of the UIStoryboardSegue
	public func performSegue(withIdentifier identifier: SegueIdentifier, sender: Any?) {
		performSegue(withIdentifier: identifier.rawValue, sender: sender)
	}
	
	/// Retrieves the SegueHandling.SegueIdentifier from a StoryboardSegue, if the value is defined as an enum
	///
	/// - Parameter segue: The UIStoryboardSegue for which to get the SegueIdentifier
	/// - Returns: Returns a SegueIdentifier if successful, or nil if not
	public func segueIdentifier(for segue: UIStoryboardSegue) -> SegueIdentifier? {
		guard let identifier = segue.identifier else { return nil }
		return SegueIdentifier(rawValue: identifier)
	}
}
