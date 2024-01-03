//
//  ViewController.swift
//  rick and morty
//
//  Created by Қадыр Маратұлы on 30.12.2023.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    var imageViewLabel = UIImageView()
    var imageViewLoad = UIImageView()
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
        self.createImageLoad()
        self.createLabel()
        self.startAnimation()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    sceneDelegate.window?.rootViewController = TabBarController()
                    
                }
            }
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
    }
    
   

    
    func createLabel() {
        let imageContainerView = UIView(frame: CGRect(x: view.center.x - 156, y: view.center.y - 300, width: 312, height: 104))
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageContainerView.frame.width, height: imageContainerView.frame.height))
        imageView.image = UIImage(named: "label")
        
        imageContainerView.layer.shadowColor = UIColor.black.cgColor
        imageContainerView.layer.shadowOpacity = 1.0
        imageContainerView.layer.shadowOffset = CGSize(width: 2, height: 2)
        imageContainerView.layer.shadowRadius = 2
        
        imageView.layer.shadowColor = UIColor.green.cgColor
        imageView.layer.shadowOpacity = 0.6
        imageView.layer.shadowOffset = CGSize(width: 4, height: 4)
        imageView.layer.shadowRadius = 6
        
        imageContainerView.addSubview(imageView)
        self.view.addSubview(imageContainerView)
    }


    func createImageLoad(){
        imageViewLoad = UIImageView(frame: CGRect(x: view.center.x - 125, y: view.center.y - 125, width: 250, height: 250))
        imageViewLoad.contentMode = .scaleToFill
        imageViewLoad.image = UIImage(named: "load")
       
        self.view.addSubview(imageViewLoad)
    }

    private func startAnimation() {
            imageViewLoad.alpha = 0.0
            imageViewLoad.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)

            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                self.imageViewLoad.alpha = 1.0
                self.imageViewLoad.transform = .identity
            }) { _ in
                self.animateRotation(scale: 1.1, duration: 1.0) {
                    self.animateRotation(scale: 0.9, duration: 1.0) {
                        self.animateRotation(scale: 1.0, duration: 1.0) {
                        }
                    }
                }
            }
        }

        private func animateRotation(scale: CGFloat, duration: TimeInterval, completion: @escaping () -> Void) {
            UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
                self.imageViewLoad.transform = self.imageViewLoad.transform.scaledBy(x: scale, y: scale).rotated(by: .pi)
            }) { _ in
                completion()
            }
        }
}

