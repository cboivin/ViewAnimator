//
//  AnimationType.swift
//  Pods-ViewAnimator_Example
//
//  Created by Marcos Griselli on 10/5/17.
//

import Foundation

/// AnimationType available to perform/
///
/// - from: Animation with direction and distance.
/// - zoom: Zoom animation.
public enum AnimationType: Animation {

    case from(direction: Direction, offset: CGFloat)
	case to(direction: Direction, offset: CGFloat)
	@available(*, deprecated, message: "Use zoomFrom instead")
	case zoom(scale: CGFloat)
    case zoomFrom(scale: CGFloat)
	case zoomTo(scale: CGFloat)
    case rotate(angle: CGFloat)
    
    /// Creates the corresponding CGAffineTransform for AnimationType.from.
    public var initialTransform: CGAffineTransform {
        switch self {
        case .from(let direction, let offset):
            let sign = direction.sign
            if direction.isVertical { return CGAffineTransform(translationX: 0, y: offset * sign) }
            return CGAffineTransform(translationX: offset * sign, y: 0)
		case .to(_, _):
			return CGAffineTransform.identity
		case .zoom(let scale), .zoomFrom(let scale):
			return CGAffineTransform(scaleX: scale, y: scale)
		case .zoomTo(_):
			return CGAffineTransform.identity
        case .rotate(let angle):
            return CGAffineTransform(rotationAngle: angle)
        }
    }
	
	public var finalTransform: CGAffineTransform {
		switch self {
		case .from(_, _):
			return CGAffineTransform.identity
		case .to(let direction, let offset):
			let sign = direction.sign
			if direction.isVertical { return CGAffineTransform(translationX: 0, y: offset * sign) }
			return CGAffineTransform(translationX: offset * sign, y: 0)
		case .zoom(_), .zoomFrom(_):
			return CGAffineTransform.identity
		case .zoomTo(let scale):
			return CGAffineTransform(scaleX: scale, y: scale)
		case .rotate(_):
			return CGAffineTransform.identity
		}
	}
    
    /// Generates a random AnimationType.
    ///
    /// - Returns: Newly generated random AnimationType.
    public static func random() -> Animation {
        let index = Int(arc4random_uniform(3))
        if index == 1 {
            return AnimationType.from(direction: Direction.random(),
                                      offset: ViewAnimatorConfig.offset)
        } else if index == 2 {
            let scale = Double.random(min: 0, max: ViewAnimatorConfig.maxZoomScale)
            return AnimationType.zoomFrom(scale: CGFloat(scale))
        }
        let angle = CGFloat.random(min: -ViewAnimatorConfig.maxRotationAngle,
                                   max: ViewAnimatorConfig.maxRotationAngle)
        return AnimationType.rotate(angle: angle)
    }
}
