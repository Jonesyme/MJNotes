//
//  ListNotesViewController.swift
//  MJNotes
//
//  Created by Mike Jones on 7/25/20.
//  Copyright © 2020 Michael Jones. All rights reserved.
//

import UIKit
import SnapKit

protocol ListNotesViewControllerDelegate: class {
    func createNewNote()
}

class ListNotesViewController: UIViewController {
    
    lazy var tableView = UITableView()
    private var viewModel: ListNotesViewModel!
    weak var delegate: ListNotesViewControllerDelegate?
    
    convenience init(viewModel: ListNotesViewModel) {
        self.init(nibName: nil, bundle: nil)
        
        self.viewModel = viewModel
        self.title = "Notes"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = NoteCell.rowHeight
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNoteTapped))]
        
        bindViewToViewModel()
        
        viewModel.loadLocalNotes()
        viewModel.loadServerNotes()
    }
    
    func bindViewToViewModel() {
        viewModel.delegate = self
    }
    
    func unbindViewToViewModel() {
        viewModel.delegate = nil
    }
    
    @objc func addNoteTapped(_ sender: UIBarButtonItem) {
        delegate?.createNewNote()
    }
}

extension ListNotesViewController: ViewModelBindingDelegate {
    func updateViews() {
        self.tableView.reloadData()
    }
}

extension ListNotesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NoteCell
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: NoteCell.identifier) as? NoteCell {
            cell = dequeuedCell
        } else {
            cell = NoteCell(style: .subtitle, reuseIdentifier: NoteCell.identifier)
        }
        let note = viewModel.note(atIndexPath: indexPath)
        
        cell.configureCell(viewModel: NoteCellViewModel(note))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.syncNote(atIndexPath: indexPath, completion: { [weak self] occured in
            if(occured) {
                let note = self?.viewModel.note(atIndexPath: indexPath)
                note?.synced = true
                self?.viewModel.list[indexPath.row] = note!
                self?.tableView.reloadData()
            }
        })
    }
}

