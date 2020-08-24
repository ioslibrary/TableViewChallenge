
import Foundation
import UIKit

// UIColor extensions
extension UIColor {
    // Navigation bar header color
    public class var appThemeColor: UIColor {
        return UIColor(red: 36.0/255.0, green: 92.0/255.0, blue: 191.0/255.0, alpha: 1)
    }
}

extension UIFont {
    // different font family with default size is 16
    static public func regular(_ size:CGFloat = 16) -> UIFont {
        return UIFont.init(name: "Roboto-Regular", size: size)!
    }
    static public func bold(_ size:CGFloat = 16) -> UIFont {
        return UIFont.init(name: "Roboto-Bold", size: size)!
    }
    static public func semiBold(_ size:CGFloat = 16) -> UIFont {
        return UIFont.init(name: "Roboto-SemiBold", size: size)!
    }
    static public func Medium(_ size:CGFloat = 16) -> UIFont {
        return UIFont.init(name: "Roboto-Medium", size: size)!
    }
    
    static public func TitleFont() -> UIFont {
        return UIFont.init(name: "Roboto-Medium", size: UIDevice.current.userInterfaceIdiom == .pad ? FontSize.iPadTitle.rawValue : FontSize.iPhoneTitle.rawValue)!
    }
    static public func DescriptionFont() -> UIFont {
        return UIFont.init(name: "Roboto-Regular", size: UIDevice.current.userInterfaceIdiom == .pad ? FontSize.iPadDescription.rawValue : FontSize.iPhoneDescription.rawValue)!
    }
}

extension UIViewController {
    // it show alert controller on main window with ok button only
    class func showAlertMessage(withTitle title: String, withMessage message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
        })
        alert.addAction(ok)
        DispatchQueue.main.async(execute: {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
        })
    }
}

