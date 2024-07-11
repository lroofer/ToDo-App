//
//  CalendarView.swift
//  ToDo App
//
//  Created by Егор Колобаев on 05.07.2024.
//

import Foundation
import UIKit

class CalendarView: UIViewController {
    var model: Todos
    var tableView: UITableView
    var updateState: (Bool, TodoItem) -> Void
    
    var selected: Int = 0
    
    lazy var dateCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 70, height: 70)
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.layer.borderColor = UIColor.gray.cgColor
        collectionView.layer.borderWidth = 0.3
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    init(model: Todos, updateState: @escaping (Bool, TodoItem) -> Void) {
        self.model = model
        self.tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.updateState = updateState
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Can't init from coder")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        dateCollectionView.dataSource = self
        dateCollectionView.delegate = self
        dateCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        dateCollectionView.selectItem(at: IndexPath(item: selected, section: 0), animated: false, scrollPosition: [.centeredHorizontally])
        view.addSubview(dateCollectionView)
        
        dateCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        dateCollectionView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 0).isActive = true
        dateCollectionView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        dateCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        dateCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        tableView.topAnchor.constraint(equalTo: dateCollectionView.bottomAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
    }
}

extension CalendarView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        model.groupedTasks.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = model.sortedDates[section]
        return model.groupedTasks[date]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        let dates = model.groupedTasks.keys.sorted()
        if let task = model.groupedTasks[dates[indexPath.section]]?[indexPath.row] {
            content.text = task.text
            content.textProperties.numberOfLines = 1
            content.textProperties.adjustsFontForContentSizeCategory = true
            if task.done {
                let attributedString = NSMutableAttributedString(string: content.text ?? "<None>")
                attributedString.addAttribute(.strikethroughStyle, value: 1, range: NSMakeRange(0, attributedString.length))
                content.attributedText = attributedString
                content.textProperties.color = .gray
            }
        }
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dates = model.groupedTasks.keys.sorted()
        if let task = model.groupedTasks[dates[indexPath.section]]?[indexPath.row] {
            updateState(true, task)
        }
        loadViewIfNeeded()
        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = model.groupedTasks.keys.sorted()[section]
        return date == 0 ? "Other" : Date.getRepresentation(from: date)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let item = model.groupedTasks[model.sortedDates[indexPath.section]]?[indexPath.row] else {
            return nil
        }
        let contextualAction = UIContextualAction(style: .normal, title: nil) { _, _, handler in
            if self.model.items[item.id] != nil {
                self.model.setItem(with: item.id, value: item.getCompleted)
            }
            DispatchQueue.main.async {
                tableView.reloadData()
            }
            handler(true)
        }
        contextualAction.image = UIImage(systemName: "checkmark.circle.fill")
        let swipeActions = UISwipeActionsConfiguration(actions: [contextualAction])
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let item = model.groupedTasks[model.sortedDates[indexPath.section]]?[indexPath.row] else {
            return nil
        }
        let contextualAction = UIContextualAction(style: .normal, title: nil) { _, _, handler in
            if self.model.items[item.id] != nil {
                self.model.setItem(with: item.id, value: item.getIncompleted)
            }
            DispatchQueue.main.async {
                tableView.reloadData()
            }
            handler(true)
        }
        contextualAction.image = UIImage(systemName: "cross.circle.fill")
        let swipeActions = UISwipeActionsConfiguration(actions: [contextualAction])
        return swipeActions
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleSections = tableView.indexPathsForVisibleRows?.map { $0.section } ?? []
        if let visibleSection = visibleSections.min(), visibleSection != selected {
            selected = visibleSection
            dateCollectionView.selectItem(at: IndexPath(item: selected, section: 0), animated: true, scrollPosition: .left)
        }
    }
    
}

extension CalendarView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.groupedTasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.row
        selected = section
        tableView.scrollToRow(at: IndexPath(row: 0, section: section), at: .top, animated: true)
        DispatchQueue.main.async {
            self.dateCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let date = model.sortedDates[indexPath.row]
        let title = UILabel()
        title.frame = cell.bounds
        title.text = (date == 0 ? "Other" : Date.getRepresentation(from: date))
        if selected == indexPath.row {
            title.backgroundColor = .secondarySystemBackground
        } else {
            title.backgroundColor = .systemBackground
        }
        cell.contentView.addSubview(title)
        return cell
    }
    
}
