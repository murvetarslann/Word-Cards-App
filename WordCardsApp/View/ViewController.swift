//
//  ViewController.swift
//  WordCardsApp
//
//  Created by Mürvet Arslan on 7.12.2025.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var wordsTableView: UITableView!
    
    private var viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addWordButtonClicked))
        
        setupTableView()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) { // Sayfa her yeniden açıldığında (görüldüğünde), kelime kaydettikten sonra tablonun yenilenmesi
        viewModel.loadWords()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = wordsTableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath)
                
        if let word = viewModel.word(at: indexPath.row) {
            
            cell.textLabel?.text = word.englishWord
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            
            cell.detailTextLabel?.text = word.turkishWord
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            viewModel.removeWord(at: indexPath.row)
        }
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    // Buradaki işleri viewDidLoad içerisinde de yapabilirdik ama daha profesyonel olmak için (ileriyi de düşünerek) ayırıp kod kirliliğini önledik
    private func setupTableView() {
        wordsTableView.dataSource = self
        wordsTableView.delegate = self
    }
    
    private func setupBindings() {
        
        viewModel.onSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.wordsTableView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.makeAlert(title: "Error!", message: error)
            }
        }
        
        viewModel.onLoading = { [weak self] isLoading in
            DispatchQueue.main.async {
                self?.view.isUserInteractionEnabled = !isLoading
            }
        }
    }
    
    @objc func addWordButtonClicked() {
        performSegue(withIdentifier: "toWordAddingArea", sender: nil)
    }
    
    
    // Kart Kısmı
    @IBAction func switchingToRandomCardButtonClicked(_ sender: Any) {
        
    }
    
    
}

