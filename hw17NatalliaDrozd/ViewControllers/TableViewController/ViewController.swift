//
//  ViewController.swift
//  hw17NatalliaDrozd
//
//  Created by Natalia Drozd on 25.05.22.
//

import UIKit

class ViewController: UIViewController {
    // кнопки навигации
    @IBOutlet weak var checkObject: UIButton!
    @IBOutlet weak var addObject: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    let fileManager = FileManager.default
    @IBOutlet weak var tableView: UITableView!
    var nameFolder: UITextField!
  //  var passwordArea: UITextField!
    var userPassword: String!
  //  var checkPassword: UITextField!
    var catalogURL: URL!
    // словарь
    var dictionary: [ContentType: [URL]] = [:]
    // переключатель
    @IBOutlet weak var switcher: UISegmentedControl!
    // массив объектов
    var selectionMode: ModeType = .navigation {
        didSet {
            addObject.isEnabled = selectionMode == .navigation
            deleteButton.isHidden = selectionMode == .navigation
            deleteButton.isEnabled = selectionMode == .navigation
            checkObject.isSelected = selectionMode == .selection
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        deleteButton.isHidden = true
        // инициалищируем кнопку удаления, чтоб можно было добавлять в навигацию
        tableView.delegate = self
        tableView.dataSource = self
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        myCollectionView.allowsMultipleSelection = true
        // проверяем наличие нового URL, т.к. по нажатию на ячейку с папкой используем один контроллер

        if catalogURL == nil {
            // путь к каталогу основной

            catalogURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            print (catalogURL)
        }
        // регистрируем ячейки
        tableView.register(UINib(nibName: "MyCell", bundle: nil), forCellReuseIdentifier: MyCell.key)
        tableView.register(UINib(nibName: "ImageViewCell", bundle: nil), forCellReuseIdentifier: ImageViewCell.key)
        myCollectionView.register(UINib(nibName: "FoldersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: FoldersCollectionViewCell.key)
        myCollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ImageCollectionViewCell.key)
        do {
            // добавляем словарь массив URL, сразу фильтруем: убираем лишнюю папку, и проверка на директорию
            dictionary[.folder] = try self.fileManager.contentsOfDirectory(at: self.catalogURL, includingPropertiesForKeys: nil).filter({$0.hasDirectoryPath && $0.lastPathComponent != ".DS_Store"})
            dictionary[.image] = try self.fileManager.contentsOfDirectory(at: self.catalogURL, includingPropertiesForKeys: nil).filter({!$0.hasDirectoryPath && $0.lastPathComponent != ".DS_Store"})
        } catch {
            return
        }
    }
    
    // переключатель между коллекцией и таблицей
    @IBAction func tappetSegment(_ sender: Any) {
        tableView.isHidden = switcher.selectedSegmentIndex != 0
        myCollectionView.isHidden = switcher.selectedSegmentIndex == 0
    }
    
    @IBAction func onAddObject(_ sender: Any) {
        
        let alert = UIAlertController(title: "Choose an action", message: nil, preferredStyle: .alert)
        let createDirectory = UIAlertAction(title: "Create a directory", style: .default) { _ in
            let alertCreateDirectory = UIAlertController(title: "Create new folder", message: "Print a name", preferredStyle: .alert)
            // добавление тектового поля для создания папки
            alertCreateDirectory.addTextField { textField in
                textField.placeholder = "Enter name"
                self.nameFolder = textField
            }
            
            let okButton = UIAlertAction(title: "Ok", style: .default) { _ in
                // проверяем на наличие текста и обрезаем строку
                guard self.nameFolder.hasText, let nameFolder = self.nameFolder.text?.trimmingCharacters(in: .whitespaces) else { return }
                do {
                    // путь для новой папки
                    let myCatalogURL = self.catalogURL.appendingPathComponent(nameFolder)
                    // создаем директорию
                    try self.fileManager.createDirectory(at: myCatalogURL, withIntermediateDirectories: false)
                    // добавляем каталог в массив и обновляем таблицу
                    self.dictionary[.folder]?.append(myCatalogURL)
                    self.tableView.reloadData()
                    self.myCollectionView.reloadData()
                    
                } catch {
                    // окно с ошибкой
                    let errorAlert = UIAlertController(title: "ERROR", message: "folder with the same name exist", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "Ok", style: .cancel)
                    errorAlert.addAction(okButton)
                    self.present(errorAlert, animated: true)
                }
            }
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .destructive)
            // добавляем вск кнопки
            alertCreateDirectory.addAction(okButton)
            alertCreateDirectory.addAction(cancelButton)
            self.present(alertCreateDirectory, animated: true)
        }
        
        // кнопка для выбора картинки
        let createImage = UIAlertAction(title: "Create an image", style: .default) { _ in
            // используем имеджпикер
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)
        }
        
        let noButton = UIAlertAction(title: "cancel", style: .destructive)
        // добавляем все кнопки
        alert.addAction(createDirectory)
        alert.addAction(createImage)
        alert.addAction(noButton)
        present(alert, animated: true)
    }
    
    @IBAction func onCheckObject(_ sender: Any) {
        checkObject.isSelected.toggle()
        if checkObject.isSelected {
            selectionMode = .selection
        } else {
            selectionMode = .navigation
        }
    }
    
    @IBAction func onDeleteButton(_ sender: Any) {
        // проверяем положение переключателя
        if switcher.selectedSegmentIndex == 0 {
            // извлекаем опционал и создаем массив с индексами выброных ячеек
            guard tableView.indexPathsForSelectedRows != nil, var arrayOfIndexes = tableView.indexPathsForSelectedRows else { return }
            // сортируем по возрастанию
            arrayOfIndexes.sort(by: >)
            // вызываем функцию удаления из дирректории и ячейки из таблицы
            removeCells(arrayOfIdexes: arrayOfIndexes)
        } else {
            
            // то же самое, только для удаления из коллекции
            guard myCollectionView.indexPathsForSelectedItems != nil, var arrayOfIndexes = myCollectionView.indexPathsForSelectedItems else { return }
            arrayOfIndexes.sort(by: >)
            removeCells(arrayOfIdexes: arrayOfIndexes)
        }
    }
}

