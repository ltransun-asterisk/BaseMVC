import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {

    // MARK: - IBOutlet

    // MARK: - Varialbes
    lazy var mainTabBarViewController: MainTabBarController? = {
        if let _tabBarController = self.tabBarController as? MainTabBarController {
            return _tabBarController
        }

        return self.view.window?.rootViewController as? MainTabBarController
    }()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.createBackMenuButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let count = self.navigationController?.viewControllers.count,
            count > 1 {
            self.enableSwipeBack(enable: true)
        } else {
            self.enableSwipeBack(enable: false)
        }
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
    private func createBackMenuButton() {

        if (self.navigationController?.viewControllers.count ?? 0) > 1 {
            // add back
            self.addBtnBackNav()
        } else {
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.hidesBackButton = true
        }
    }

    func enableSwipeBack(enable: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = enable
    }

    func setNavTitle(title: String?) {
        self.navigationItem.title = title
    }

    func addBtnBackNav(tinColor: UIColor? = nil) {
        let backButton = self.createBtnNavWithImage(image: #imageLiteral(resourceName: "ic_arrow_back"), target: self, action: #selector(BaseViewController.actionTouchBtnBack), tinColor: tinColor)
        self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: backButton), animated: false)
    }

    func addBtnLeftNavWithImage(image: UIImage?, tinColor: UIColor? = nil) {
        let leftButton = self.createBtnNavWithImage(image: image, target: self, action: #selector(BaseViewController.actionTouchBtnLeft), tinColor: tinColor)
        self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: leftButton), animated: false)
    }

    func addBtnRightNavWithImage(image: UIImage?, tinColor: UIColor? = nil) {
        let rightButton = self.createBtnNavWithImage(image: image, target: self, action: #selector(BaseViewController.actionTouchBtnRight), tinColor: tinColor)
        self.navigationItem.setRightBarButton(UIBarButtonItem(customView: rightButton), animated: false)
    }

    func addBtnLeftNavWithTitle(title: String?) {
        if let title = title {
            let leftNavBtn = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(BaseViewController.actionTouchBtnLeft))
            self.navigationItem.leftBarButtonItem = leftNavBtn
        }
    }

    func addBtnRightNavWithTitle(title: String?) {
        let rightNavBtn = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(BaseViewController.actionTouchBtnRight))
        self.navigationItem.rightBarButtonItem = rightNavBtn
    }

    private func createBtnNavWithImage(image: UIImage?, target: AnyObject?, action: Selector, tinColor: UIColor? = nil) -> UIButton {
        let navButton: UIButton = UIButton(type: UIButtonType.system)
        navButton.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        navButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        navButton.setImage(image, for: UIControlState.normal)
        navButton.tintColor = tinColor ?? UIColor.black
        return navButton
    }

    // MARK: - Actions
    func actionTouchBtnBack() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    func actionTouchBtnLeft() {
    }

    func actionTouchBtnRight() {
    }

    // MARK: - Call Api

    // MARK: - Functions

}
