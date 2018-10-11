//
//  WalkthroughViewController.swift
//  Tippy
//
//  Created by James Pamplona on 2/21/16.
//  Copyright © 2016 James Pamplona. All rights reserved.
//

import UIKit
import Gecco

class WalkthroughViewController: SpotlightViewController {

    @IBOutlet weak var annotation: UILabel!
    
    @IBOutlet var annotations: [UILabel]!
    var views: [UIView] = []
    var stepIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func next(animated: Bool) {
        guard stepIndex < views.count else { dismiss(animated: true, completion: nil); return }
        updateAnnotations(animated: animated)
            spotlightView.appear(Spotlight.RoundedRect(view: views[stepIndex], margin: 5, cornerRadius: 20))
    
        stepIndex += 1
    }

    func updateAnnotations(animated: Bool) {
        annotations.enumerated().forEach {
            (index, view) -> () in
            UIView.animate(withDuration: animated ? 0.25 : 0, animations: {
            view.alpha = index == self.stepIndex ? 1 : 0
            }) 
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension WalkthroughViewController: SpotlightViewControllerDelegate {
    func spotlightViewControllerWillPresent(_ viewController: SpotlightViewController, animated: Bool) {
        next(animated: false)
    }
    
    func spotlightViewControllerTapped(_ viewController: SpotlightViewController, isInsideSpotlight: Bool) {
        next(animated: true)
    }
    
    func spotlightViewControllerWillDismiss(_ viewController: SpotlightViewController, animated: Bool) {
        spotlightView.disappear()
    }
}
