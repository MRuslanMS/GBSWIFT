//
//  MessegeController.swift
//  VKProject1
//
//  Created by xc553a8 on 02.09.2021.
//

import UIKit

class MessegeController: UIViewController {
    
    @IBOutlet var backTitleImageView: UIView!
    
    private var displayLink: CADisplayLink?
    private var loadingLabeltext: String = ""
    private var loadingLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 40)
        return label
    }()
    private var firstPoint: UILabel = {
        let firstPoint = UILabel()
        firstPoint.translatesAutoresizingMaskIntoConstraints = false
        firstPoint.text = "."
        firstPoint.textColor = UIColor.gray
        firstPoint.font = UIFont.boldSystemFont(ofSize: 100)
        return firstPoint
    }()
    private var secondPoint: UILabel = {
        let secondPoint = UILabel()
        secondPoint.translatesAutoresizingMaskIntoConstraints = false
        secondPoint.text = "."
        secondPoint.textColor = UIColor.gray
        secondPoint.font = UIFont.boldSystemFont(ofSize: 100)
        return secondPoint
    }()
    private var thirdPoint: UILabel = {
        let thirdPoint = UILabel()
        thirdPoint.translatesAutoresizingMaskIntoConstraints = false
        thirdPoint.text = "."
        thirdPoint.textColor = UIColor.gray
        thirdPoint.font = UIFont.boldSystemFont(ofSize: 100)
        return thirdPoint
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      pathAnimation()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        
    }
    
    @objc private func showHideDots() {
        if !loadingLabeltext.contains("...") {
            loadingLabeltext = loadingLabeltext.appending(".")
        } else {
            loadingLabeltext = "Loading "
        }
        loadingLabel.text = loadingLabeltext
    }
    
        
    private func pathAnimation() {
        let cloudView = UIView()

        view.addSubview(cloudView)
        cloudView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cloudView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cloudView.bottomAnchor.constraint(equalTo: backTitleImageView.bottomAnchor, constant: -10),
            cloudView.widthAnchor.constraint(equalToConstant: 120),
            cloudView.heightAnchor.constraint(equalToConstant: 70)
        ])

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 10, y: 60))
        path.addQuadCurve(to: CGPoint(x: 20, y: 40), controlPoint: CGPoint(x: 5, y: 50))
        path.addQuadCurve(to: CGPoint(x: 40, y: 20), controlPoint: CGPoint(x: 20, y: 20))
        path.addQuadCurve(to: CGPoint(x: 70, y: 20), controlPoint: CGPoint(x: 55, y: 0))
        path.addQuadCurve(to: CGPoint(x: 80, y: 30), controlPoint: CGPoint(x: 80, y: 20))
        path.addQuadCurve(to: CGPoint(x: 110, y: 60), controlPoint: CGPoint(x: 110, y: 30))
        path.close()

        let layerAnimation = CAShapeLayer()
        layerAnimation.path = path.cgPath
        layerAnimation.strokeColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        layerAnimation.fillColor = UIColor.clear.cgColor
        layerAnimation.lineWidth = 8
        layerAnimation.lineCap = .round

        cloudView.layer.addSublayer(layerAnimation)

        let pathAnimationEnd = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimationEnd.fromValue = 0
        pathAnimationEnd.toValue = 1
        pathAnimationEnd.duration = 2
        pathAnimationEnd.fillMode = .both
        pathAnimationEnd.isRemovedOnCompletion = false
        layerAnimation.add(pathAnimationEnd, forKey: nil)

        let pathAnimationStart = CABasicAnimation(keyPath: "strokeStart")
        pathAnimationStart.fromValue = 0
        pathAnimationStart.toValue = 1
        pathAnimationStart.duration = 2
        pathAnimationStart.fillMode = .both
        pathAnimationStart.isRemovedOnCompletion = false
        pathAnimationStart.beginTime = 1

        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 3
        animationGroup.fillMode = CAMediaTimingFillMode.backwards
        animationGroup.animations = [pathAnimationEnd, pathAnimationStart]
        animationGroup.repeatCount = .infinity
        layerAnimation.add(animationGroup, forKey: nil)
    }



   
}


