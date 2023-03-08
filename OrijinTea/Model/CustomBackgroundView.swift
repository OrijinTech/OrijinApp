//
//  customBackgroundView.swift
//  OrijinTea
//
//  Created by Yongxiang Jin on 3/3/23.
//

import UIKit

class CustomBackgroundView: UIView {
    
    // Add any subviews you need to the background view here
    let imageView = UIImageView()
    var widthRatio = 0.4
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Configure the subviews and add them to the background view
        imageView.backgroundColor = .red
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update the layout of the subviews here as needed
        imageView.frame = CGRect(x: frame.width*widthRatio, y: 0, width: frame.width*(3/4), height: frame.height)
    }
    
    func setImg(_ image: String){
        imageView.image = UIImage(named: image)
        imageView.alpha = 0.85
        addSubview(imageView)
    }
    
}
