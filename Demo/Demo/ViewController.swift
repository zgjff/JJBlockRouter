//
//  ViewController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

private let cellIdentifier = "cell"
class ViewController: UIViewController {
    private lazy var tableView = UITableView()
    private var actions: [RootRowAction] = []
}

extension ViewController {
    override func loadView() {
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Root"
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .black
        }
        configDatas()
        tableView.rowHeight = 50
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        if #available(iOS 14.0, *) {
            var configuration = cell.defaultContentConfiguration()
            configuration.text = actions[indexPath.row].title
            cell.contentConfiguration = configuration
        } else {
            cell.textLabel?.text = actions[indexPath.row].title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let str = actions[indexPath.row].action
        if str.isEmpty {
            return
        }
        let sel = Selector(str)
        perform(sel)
    }
}

private extension ViewController {
    func configDatas() {
        actions = [
            RootRowAction(title: "Push With Eunm", action: "onClickPushUsingEnum"),
            RootRowAction(title: "Push With Path", action: "onClickPushUsingPath"),
            RootRowAction(title: "Push With Url", action: "onClickPushUsingUrl"),
            RootRowAction(title: "Present", action: "onClickPresent"),
            RootRowAction(title: "PushPop Style Present", action: "onClickPushPopStylePresent"),
            RootRowAction(title: "Center Alert ", action: "onClickAlertCenter"),
            RootRowAction(title: "block 1 ", action: "onClickBackBlock"),
            RootRowAction(title: "block 2 ", action: "onClickFrontBlock"),
            RootRowAction(title: "block 2 ", action: "onClickMapBlock"),
            RootRowAction(title: "map block ", action: "onClickMapBlock"),
            RootRowAction(title: "pass parameter By url", action: "onClickPassParameterByUrl"),
            RootRowAction(title: "pass parameter By url with query", action: "onClickPassParameterByUrlWithQuery"),
            RootRowAction(title: "pass parameter By context", action: "onClickPassParameterByContext"),
            RootRowAction(title: "pass parameter By url and context", action: "onClickPassParameterMixUrlAndContext"),
            RootRowAction(title: "pass parameter for controller init", action: "onClickHandleParameterForInit"),
            RootRowAction(title: "update ui when match same route", action: "onClickUpdateUIWhenMatchSameController"),
        ]
    }
}

// MARK: - Simple
private extension ViewController {
    @IBAction func onClickPushUsingEnum() {
        JJBlockRouter.default.open(SimpleRouter.systemPush)(self)
    }
    
    @IBAction func onClickPushUsingPath() {
        JJBlockRouter.default.open("/app/systemPush")(nil)
    }
    
    @IBAction func onClickPushUsingUrl() {
        if let url = URL(string: "https://www.appwebsite.com/app/systemPush/") {
            JJBlockRouter.default.open(url)(self)
        }
    }
    
    @IBAction func onClickPresent() {
        JJBlockRouter.default.open(SimpleRouter.systemPresent)(nil)
    }
    
    @IBAction func onClickPushPopStylePresent() {
        JJBlockRouter.default.open(SimpleRouter.pushPopStylePreset)(self)
    }
    
    @IBAction func onClickAlertCenter() {
        JJBlockRouter.default.open(SimpleRouter.alertCenter)(self)
    }
}

// MARK: - block回调
private extension ViewController {
    // 正常block回调: A跳转B, B通过路由block将数据回调给A
    @IBAction func onClickBackBlock() {
        let router = JJBlockRouter.default.open(BlockRouter.backBlock)(self)
        router?.register(blockName: "onSend", callback: { obj in
            print("get data: \(obj) from router block")
        })
    }
    
    // 非正常block回调
    // A跳转B, A通过路由block将实时数据回调给B
    @IBAction func onClickFrontBlock() {
        JJBlockRouter.default.open(BlockRouter.frontBlockA)(self)
    }
    
    // 非正常block回调
    // A需要跳转B,但是条件达不到,需要跳转到其它路由界面C,此时可以正常拿到C的回调
    @IBAction func onClickMapBlock() {
        let router = JJBlockRouter.default.open(BlockRouter.mapBlock)(self)
        router?.register(blockName: "loginSuccess", callback: { _ in
            print("登录成功")
        })
    }
}

// MARK: - 传参数
private extension ViewController {
    @IBAction func onClickPassParameterByUrl() {
        JJBlockRouter.default.open("/app/passParameterByUrl/12/jack")(self)
    }
    
    @IBAction func onClickPassParameterByUrlWithQuery() {
        JJBlockRouter.default.open("/app/search?name=lili&age=18")(self)
    }
    
    @IBAction func onClickPassParameterByContext() {
        JJBlockRouter.default.open(PassParameterRouter.byContext, context: 12)(self)
    }
    
    @IBAction func onClickPassParameterMixUrlAndContext() {        JJBlockRouter.default.open("/app/mixUrlAndContext/12/keke", context: arc4random_uniform(2) == 0)(self)
    }
    
    @IBAction func onClickHandleParameterForInit() {
        JJBlockRouter.default.open("/app/parameterForInit/66")(self)
    }
    
    @IBAction func onClickUpdateUIWhenMatchSameController() {
        JJBlockRouter.default.open("/app/updateUIMatchedSame/18")(self)
    }
}