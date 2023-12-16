//
//  MainViewController.swift
//  SwiftDataUIKitExtensionsExample
//
//  Created by Leo Ho on 2023/12/17.
//

import SwiftHelpers
import UIKit

class MainViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var txfInput: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var tvTodos: UITableView!
    
    // MARK: - Variables
    
    private var todos: [Todo] = []
    
    private var contentUnavailableView: UIContentUnavailableView?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        LocalDatabaseManager.shared.modelDidChangeListener = modelDidChangeListener
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - UI Settings
    
    fileprivate func setupUI() {
        setupButton()
        setupTableView()
        if todos.count.isEqual(to: 0) {
            setupContentUnavailableView()
        }
        
        setupTapGesture()
    }
    
    fileprivate func setupButton() {
        btnSave.setTitle("Save", for: .normal)
    }
    
    fileprivate func setupTableView() {
        tvTodos.delegate = self
        tvTodos.dataSource = self
        tvTodos.register(TodoTableViewCell.loadFromNib(),
                         forCellReuseIdentifier: TodoTableViewCell.identifier)
    }
    
    fileprivate func setupContentUnavailableView() {
        var configuration: UIContentUnavailableConfiguration = .empty()
        configuration.text = "No Todo items..."
        configuration.image = UIImage(symbols: .xmarkCircle)
        
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.title = "Load Todo items"
        configuration.button = buttonConfiguration
        configuration.buttonProperties.primaryAction = UIAction(title: "") { [unowned self] _ in
            fetchData()
        }
        
        let content = UIContentUnavailableView(configuration: configuration)
        content.frame = tvTodos.frame
        
        contentUnavailableView = content
        
        view.addSubview(contentUnavailableView!)
    }
    
    fileprivate func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - IBAction
    
    @IBAction func btnSaveClicked(_ sender: UIButton) {
        guard let text = txfInput.text, !text.isEmpty else {
            return
        }
        let todo = Todo(taskName: text, time: Date().timeIntervalSince1970)
        LocalDatabaseManager.shared.create(with: todo)
    }
    
    // MARK: - Functions
    
    private func fetchData() {
        LocalDatabaseManager.shared.read { result in
            switch result {
            case .success(let todos):
                self.todos = todos.sorted(by: { $0.time < $1.time })
                DispatchQueue.main.async {
                    self.tvTodos.reloadData()
                    if todos.count > 0 {
                        self.contentUnavailableView!.removeFromSuperview()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @MainActor private func modelDidChangeListener() {
        fetchData()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    // UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.identifier,
                                                       for: indexPath) as? TodoTableViewCell else {
            fatalError("TodoTableViewCell Load Failed")
        }
        cell.setInit(name: todos[indexPath.row].taskName)
        return cell
    }
    
    // UITableViewDelegate
}

// MARK: - Protocol



// MARK: - Previews

@available(iOS 17.0, *)
#Preview {
    MainViewController()
}
