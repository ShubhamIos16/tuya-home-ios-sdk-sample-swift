//
//  HomeListTableViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import TuyaSmartDeviceKit

class HomeListTableViewController: UITableViewController {
    
    private let homeManager = TuyaSmartHomeManager()
    private var homeList = [TuyaSmartHomeModel]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        homeManager.getHomeList { [weak self] (homeModels) in
            guard let self = self else { return }
            self.homeList = homeModels ?? []
            self.tableView.reloadData()
        } failure: { [weak self] (error) in
            guard let self = self else { return }
            let errorMessage = error?.localizedDescription ?? ""
            Alert.showBasicAlert(on: self, with: "Failed to Fetch Home List", message: errorMessage)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "home-list-cell")!
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = homeList[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.performSegue(withIdentifier: "show-home-detail", sender: homeList[indexPath.row])
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "show-home-detail" else { return }
        guard let model = sender as? TuyaSmartHomeModel else { return }
        
        let destinationVC = segue.destination as! HomeDetailTableViewController
        destinationVC.homeModel = model
    }
}
