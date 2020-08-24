

import UIKit
import SDWebImage


class ProductCell : UITableViewCell {
    
    var product : Product? {
        didSet {
            // update the imageview on main thread once it has been downloaded from server
            DispatchQueue.main.async {
                self.productImage.sd_setImage(with: URL(string: self.product?.imageURL ?? ""), placeholderImage: UIImage(named: "applelogo"))
            }
            self.productNameLabel.text = self.product?.title
            self.productDescriptionLabel.text = self.product?.description
        }
    }
    
    //MARK: declare and initialse properties
    private let productNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.TitleFont()
        lbl.textAlignment = .left
        return lbl
    }()
    
    
    private let productDescriptionLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.DescriptionFont()
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let productImage : UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "applelogo"))
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 5
        return imgView
    }()
    
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // add properties to table view cell
        contentView.addSubview(productNameLabel)
        contentView.addSubview(productDescriptionLabel)
        contentView.addSubview(productImage)
        
        // To set cell minimum height. It will be used when either title or description or both are null
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: UIDevice.current.userInterfaceIdiom == .pad ? 108 : 72).isActive = true
        
        let marginGuide = contentView.layoutMarginsGuide
        
        // Product Imageview Constraint
        productImage.contentMode = .scaleAspectFit
        productImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            productImage.widthAnchor.constraint(equalToConstant: UIDevice.current.userInterfaceIdiom == .pad ? FontSize.iPadImageWidthHeight.rawValue : FontSize.iPhoneImageWidthHeight.rawValue),
            productImage.heightAnchor.constraint(equalToConstant:  UIDevice.current.userInterfaceIdiom == .pad ? FontSize.iPadImageWidthHeight.rawValue : FontSize.iPhoneImageWidthHeight.rawValue),
            productImage.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: -5),
            productImage.leftAnchor.constraint(equalTo: marginGuide.leftAnchor),
        ])

        // Product Name label Constraint
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        productNameLabel.numberOfLines = 0
        productNameLabel.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 10).isActive = true
        productNameLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        productNameLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        
        // Product Description label Constraint
        productDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        productDescriptionLabel.numberOfLines = 0
        productDescriptionLabel.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 10).isActive = true
        productDescriptionLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        productDescriptionLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        productDescriptionLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

