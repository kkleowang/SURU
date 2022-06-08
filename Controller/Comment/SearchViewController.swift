//
//  SearchController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/6/6.
//

import UIKit
import CoreLocation
protocol SearchViewControllerDelegate: AnyObject {
    func didSelectedStore(_ view: SearchViewController, storeID: String)
    func didSelectedMeal(_ view: SearchViewController, meal: String)
}

class SearchViewController: UIViewController {
    weak var delegate: SearchViewControllerDelegate?
    private var tableView = UITableView(frame: .zero)
    private lazy var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    
    var storeData: [Store] = []
    
    var filteredStoreData: [Store] = []
    var selectStoreID: String!
    var mealData: [String]!
    var filteredMealData: [String]!
    var isSearchResults = false
    
    var isMealSelection = false
    var isGotLocaltion: Bool {
        return CoreLocationManager.shared.currentLocation != CLLocation(latitude: 0, longitude: 0)
    }
    var searchPlaceholder = "搜尋店家"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
        configStatus()
        if !isMealSelection {
            configDistance()
        } else {
            configStatus()
        }
    }
    func configStatus() {
        if let store = storeData.first(where: { $0.storeID == selectStoreID }) {
            mealData = store.meals
        }
    }
    private func configDistance() {
        if let localtion = CoreLocationManager.shared.currentLocation {
            if isGotLocaltion {
                storeData.sort {
                    localtion.distance(from: CLLocation(latitude: $0.coordinate.lat, longitude: $0.coordinate.long)) <
                        localtion.distance(from: CLLocation(latitude: $1.coordinate.lat, longitude: $1.coordinate.long))
                }
            }
        }
    }
    private func setupSearchBar() {
        searchBar.placeholder = searchPlaceholder
        searchBar.delegate = self
        let leftNavBarButton = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
    }
    private func setupTableView() {
        view.stickSubViewSafeArea(tableView)
        tableView.registerCellWithNib(identifier: ResultsCell.identifier, bundle: nil)
        tableView.registerCellWithNib(identifier: MealResultsCell.identifier, bundle: nil)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        configStoreData(srarchText: searchText)
    }
    private func configStoreData(srarchText: String) {
        if !isMealSelection {
            if srarchText.isEmpty, isSearchResults {
                isSearchResults = false
                filteredStoreData = storeData
            } else {
                isSearchResults = true
                filteredStoreData = storeData.filter {
                    let title = $0.name
                    let address = $0.address
                    let isMatchName = title.localizedStandardContains(srarchText)
                    let isMatchAddress = address.localizedStandardContains(srarchText)
                    if isMatchName || isMatchAddress == true {
                        return true
                    } else {
                        return false
                    }
                }
            }
        } else {
            if srarchText.isEmpty, isSearchResults {
                filteredMealData = mealData
                isSearchResults = false
            } else {
                isSearchResults = true
                filteredMealData = mealData.filter {
                    let isMatchName = $0.localizedStandardContains(srarchText)
                    return isMatchName
                }
                isSearchResults = true
            }
        }
        tableView.reloadData()
    }
}
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isMealSelection {
            if isSearchResults {
                return filteredStoreData.count
            } else {
                return storeData.count
            }
        } else {
            if isSearchResults {
                return filteredMealData.count
            } else {
                return mealData.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isMealSelection {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultsCell.identifier, for: indexPath) as? ResultsCell else { return ResultsCell() }
            var store: Store?
            
            if isSearchResults {
                store = filteredStoreData[indexPath.row]
            } else {
                store = storeData[indexPath.row]
            }
            guard let store = store else { return cell }
            cell.layoutCell(store: store)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MealResultsCell.identifier, for: indexPath) as? MealResultsCell else { return MealResultsCell() }
            if isSearchResults {
                cell.mealNameLabel.text = filteredMealData[indexPath.row]
            } else {
                cell.mealNameLabel.text = mealData[indexPath.row]
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isMealSelection {
            if isSearchResults {
                self.delegate?.didSelectedStore(self, storeID: filteredStoreData[indexPath.row].name)
            } else {
                self.delegate?.didSelectedStore(self, storeID: storeData[indexPath.row].name)
            }
        } else {
            if isSearchResults {
                self.delegate?.didSelectedMeal(self, meal: filteredMealData[indexPath.row])
                
            } else {
                self.delegate?.didSelectedMeal(self, meal: mealData[indexPath.row])
            }
        }
        navigationController?.popViewController(animated: true)
    }
}
