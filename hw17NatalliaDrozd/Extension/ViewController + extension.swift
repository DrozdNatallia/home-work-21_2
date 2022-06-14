//
//  ViewController + extension.swift
//  hw17NatalliaDrozd
//
//  Created by Natalia Drozd on 26.05.22.
//
import Foundation
import UIKit


// MARK: TableView
extension ViewController: UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // количество секций, по количеству ключей в словаре
        return dictionary.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let key = ContentType(rawValue: section), let values = dictionary[key] else { return 0 }

        return values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // проверяем файл по ключу, если картинка, то добаляем ячейку для картинки
        guard let key = ContentType(rawValue: indexPath.section), let values = dictionary[key] else {
            return UITableViewCell()
        }
            if key == .folder {
                if let cell = tableView.dequeueReusableCell(withIdentifier: MyCell.key) as? MyCell {
                    //добавляем картинку и  текст с названием папки
                    cell.label.text = values[indexPath.row].lastPathComponent
                    cell.imageView?.image = UIImage(systemName: "folder")
                    return cell
                }
            }
            if let imageCell = tableView.dequeueReusableCell(withIdentifier: ImageViewCell.key) as? ImageViewCell {
                // добавляем картинку
                imageCell.myImageView.image = UIImage(contentsOfFile:  values[indexPath.row].path)
                return imageCell
            }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // размер ячейки
        50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // добавляем тайтлы
        guard let key = ContentType(rawValue: section), let values = dictionary[key], !values.isEmpty else { return nil }
            if key == .folder {
                return ContentType.folder.description
            }

        return ContentType.image.description
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // по нажатию на ячейку проверяем нажата ли кнопка выбора
        
        switch selectionMode {
        case .navigation:
            // если не нажата, то вызываем функцию для перехода
            tappedAtCell(key: ContentType(rawValue: indexPath.section), indexPath: indexPath)
            tableView.deselectRow(at: indexPath, animated: true)
        case .selection:
                deleteButton.isEnabled = tableView.indexPathsForSelectedRows != nil
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // проверяем, когда снимаем выбор со всех ячеек
            deleteButton.isEnabled = tableView.indexPathsForSelectedRows != nil
    }
    
    
    
    // MARK: COLLECTION VIEW
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // количесвто секций в коллекции по ключу
        dictionary.keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // количесвто ячеек
        guard let key = ContentType(rawValue: section), let values = dictionary[key] else { return 0 }
        
        return values.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // меняем информацию как и на тэйбл вью
        guard let key = ContentType(rawValue: indexPath.section), let values = dictionary[key] else { return UICollectionViewCell() }

            if key == .folder {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoldersCollectionViewCell.key, for: indexPath) as? FoldersCollectionViewCell {
                    cell.myLabel.text = values[indexPath.row].lastPathComponent
                    return cell
                }
            }
            
            if let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.key, for: indexPath) as? ImageCollectionViewCell {
                imageCell.myImageView.image = UIImage(contentsOfFile:  values[indexPath.row].path)
                return imageCell
            }
        return UICollectionViewCell()
    }
    
    // нажатие на ячейку
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch selectionMode {
        case .navigation:
            tappedAtCell(key: ContentType(rawValue: indexPath.section), indexPath: indexPath)
                collectionView.deselectItem(at: indexPath, animated: true)
        case .selection:
                deleteButton.isEnabled = myCollectionView.indexPathsForSelectedItems != nil
        }

    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    deleteButton.isEnabled = myCollectionView.indexPathsForSelectedItems?.count != 0

    }
}


// MARK: InagePicker
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imageURL = info[.imageURL] as? URL,
           let image = info[.originalImage] as? UIImage {
            // получаем адрес для картинки
            let newImageURL = catalogURL.appendingPathComponent(imageURL.lastPathComponent)
            // формат
            let imageJPEG = image.jpegData(compressionQuality: 1)
            do {
                try imageJPEG?.write(to: newImageURL)
                // добавляем картинку
                dictionary[.image]?.append(newImageURL)
                tableView.reloadData()
                myCollectionView.reloadData()
            } catch {
                print ("Error")
            }
            dismiss(animated: true)
        }
    }
}





