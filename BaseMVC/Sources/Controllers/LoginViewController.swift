//
//  LoginViewController.swift
//  BaseMVC
//
//  Created by Henry Tran on 6/21/17.
//  Copyright © 2017 THL. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    // MARK: - IBOutlet

    // MARK: - Varialbes

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBtnRightNavWithTitle(title: "Setting")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    // MARK: - Setup View

    // MARK: - Call Api

    // MARK: - Actions
    @IBAction func actionTouchBtnLogin(_ sender: Any) {
        self.mainTabBarViewController?.setupMainApp()
        self.dismiss(animated: true, completion: nil)
    }

    override func actionTouchBtnRight() {
        let userSettingVC = LoginViewController.getViewControllerFromStoryboard(Storyboard.User.name)
        let navigationVC = UINavigationController(rootViewController: userSettingVC)

        // create animator for present
        //        let animator = Animator(presentedType: .push, dismissedType: .push)
        //        self.menuViewController?.animator = animator
        //
        //        navigationVC.transitioningDelegate = self.menuViewController

        // present
        self.present(navigationVC, animated: true, completion: nil)
    }

    // MARK: - Functions

}
