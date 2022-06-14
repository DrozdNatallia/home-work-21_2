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

        newScroll.delegate = self
       // myScrollView.backgroundColor = .orange
       // contentView.backgroundColor = .blue
        newScroll.minimumZoomScale = 1.0
        newScroll.maximumZoomScale = 2.0
        for i in imageArray {
            
            newScroll = UIScrollView()
           // newScroll.backgroundColor = .red
            contentView.addArrangedSubview(newScroll)
            newScroll.snp.makeConstraints { make in
                make.width.equalTo(view.snp.width)
                make.height.equalTo(view.snp.height)
            }
            
            newView = UIView()
            //newView.backgroundColor = .green
            newScroll.addSubview(newView)
            newView.snp.makeConstraints { make in
                make.width.equalTo(view.snp.width)
                make.height.equalTo(view.snp.height)
            }
            
            imageView = UIImageView()
            imageView.image = i
            imageView.contentMode = .scaleAspectFit
           // imageView.backgroundColor = .blue
            newView.addSubview(imageView)
            //contentView.addArrangedSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.width.equalTo(view.snp.width)
                make.height.equalTo(view.snp.height)
             }
//
//            newScroll.minimumZoomScale = 1.0
//            newScroll.maximumZoomScale = 5.0
            
           
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
//
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print(scrollView.zoomScale)
        print("new")
        print(newScroll.zoomScale)
        print(myScrollView.zoomScale)
        scrollView.isPagingEnabled = scrollView.zoomScale == 1
    }
//    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
//
//    }

}

