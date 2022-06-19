//
//  ImageViewController.swift
//  hw17NatalliaDrozd
//
//  Created by Natalia Drozd on 28.05.22.
//

import UIKit
import SnapKit
class ImageViewController: UIViewController, UIScrollViewDelegate  {

    @IBOutlet weak var contentView: UIStackView!
    @IBOutlet weak var myScrollView: UIScrollView!
    var imageArray = [UIImage]()
    var newView = UIView()
    var newScroll = UIScrollView()
    var imageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()

        myScrollView.delegate = self
        myScrollView.isPagingEnabled = true
        
        for (index, element) in imageArray.enumerated() {
            
            newScroll = UIScrollView()
            contentView.addArrangedSubview(newScroll)
            newScroll.snp.makeConstraints { make in
                make.width.equalTo(view.snp.width)
                make.height.equalTo(view.snp.height)
            }
            
            newView = UIView()
            newScroll.addSubview(newView)
            newView.snp.makeConstraints { make in
                make.width.equalTo(view.snp.width)
                make.height.equalTo(view.snp.height)
            }
            
            imageView = UIImageView()
            imageView.image = element
            imageView.contentMode = .scaleAspectFit
            newView.addSubview(imageView)
            //contentView.addArrangedSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.width.equalTo(view.snp.width)
                make.height.equalTo(view.snp.height)
             }
            imageView.tag = index + 1
            newScroll.delegate = self
            newScroll.minimumZoomScale = 1.0
            newScroll.maximumZoomScale = 5.0
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        let page = Int(myScrollView.contentOffset.x / myScrollView.frame.size.width) + 1
        let image = view.viewWithTag(page)
        return image
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollView.isPagingEnabled = scrollView.zoomScale == 1
    }
}

