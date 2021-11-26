//
//  ViewController.swift
//  Metal3DViewer
//
//  Created by admin on 15/09/21.
//

import UIKit


class ViewController: UIViewController {

    weak var metalView: MetalParticleView!
    @IBOutlet weak var bgImageView: UIImageView!
    
    
    override func loadView() {
        super.loadView()
        
        let metalView = MetalParticleView(frame: .zero)
        metalView.translatesAutoresizingMaskIntoConstraints = false
        self.bgImageView.addSubview(metalView)
        
        NSLayoutConstraint.activate([
            metalView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 250),
            metalView.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: -200),
            metalView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            metalView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            ])
        
        self.metalView = metalView
        self.metalView.layer.isOpaque = false
        
        
    
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


}

