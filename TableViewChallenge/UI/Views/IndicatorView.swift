

import Foundation
import UIKit

class IndicatorView {
    
    // MARK: Class Properties
    public static let shared = IndicatorView()
    public var containerView = UIView()
    public var progressView = UIView()
    public var activityIndicator = UIActivityIndicatorView()

    public var backgroundColor = UIColor.white.withAlphaComponent(0.3)
    public var forgroundColor = UIColor(red: 27.0/255.0, green: 27.0/255.0, blue: 27.0/255.0, alpha: 0.7)
    public var size: CGSize {
        didSet {
            if self.size.height < 0 {
                self.size.height = 0
            }
            
            if self.size.width < 0 {
                self.size.width = 0
            }
        }
    }

    // Create progress bar style
    public var activityStyle: UIActivityIndicatorView.Style = UIActivityIndicatorView.Style.whiteLarge
    private var activeConstraints = [NSLayoutConstraint]()

    // MARK: - Initializer
    public init() {
        self.size = CGSize(width: 80, height: 80)
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.progressView.clipsToBounds = true
        self.progressView.layer.cornerRadius = 10
        self.progressView.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Display

    // Adds the progress views to the top most view
    open func showProgressView() {

        guard let topView = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?
.rootViewController?.view else {
            return
        }
        
        containerView.backgroundColor = self.backgroundColor
        progressView.backgroundColor = self.forgroundColor
        activityIndicator.style = self.activityStyle

        UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.addSubview(containerView)
        progressView.addSubview(activityIndicator)
        containerView.addSubview(progressView)
        
        // add Constraints to class properties
        activeConstraints = [
            containerView.heightAnchor.constraint(equalTo: topView.heightAnchor),
            containerView.widthAnchor.constraint(equalTo: topView.widthAnchor),
            containerView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: topView.topAnchor),

            progressView.heightAnchor.constraint(equalToConstant: self.size.height),
            progressView.widthAnchor.constraint(equalToConstant: self.size.width),
            progressView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            progressView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            activityIndicator.heightAnchor.constraint(equalToConstant: self.size.height),
            activityIndicator.widthAnchor.constraint(equalToConstant: self.size.width),
            activityIndicator.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: progressView.centerXAnchor)
        ]
        
        for constraint in activeConstraints {
            constraint.isActive = true
        }

        activityIndicator.startAnimating()
    }
    
    // Hides the progress views from their superview
    open func hideProgressView() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.containerView.removeFromSuperview()
            for constraint in self.activeConstraints {
                constraint.isActive = false
            }
            self.activeConstraints.removeAll()
        }
    }
}
