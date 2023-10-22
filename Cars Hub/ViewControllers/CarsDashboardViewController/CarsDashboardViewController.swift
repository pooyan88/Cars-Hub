//
//  ViewController.swift
//  Cars Hub
//
//  Created by Pooyan J on 7/5/1402 AP.
//

import UIKit
import SDWebImage

class CarsDashboardViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var currentMilesTextField: UITextField!
    @IBOutlet weak var engineOilInputTextField: UITextField!
    @IBOutlet weak var changeEngineOilHelperLabel: UILabel!
    @IBOutlet weak var transmissionOilInputTextField: UITextField!
    @IBOutlet weak var changeTransmissionHelperLabel: UILabel!
    @IBOutlet weak var timingBeltInputTextField: UITextField!
    @IBOutlet weak var timingBeltHelperLabel: UILabel!
    @IBOutlet weak var filtersInputTextField: UITextField!
    @IBOutlet weak var changeFiltersHelperLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var carImageView: UIImageView!
    @IBAction func searchButtonAction(_ sender: Any) {
        coordinator?.gotoCarsListViewController(with: viewModel.carsData, delegate: self)
    }
    
    var coordinator: MainCoordinator?
    var viewModel: CarsDashboardViewModel!
    var currentMiles: Int {
        return Int(currentMilesTextField.text ?? "?") ?? 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupViewModel()
        hideKeyboardWhenTappedAround()
    }
}

//MARK: - Setup Functions
extension CarsDashboardViewController {
    
    private func setupViewModel() {
        viewModel = CarsDashboardViewModel(showLoading: { [weak self] isAnimating in
            self?.setupLoadingIndicator(isAnimating: isAnimating)
        }, isComponentsEnable: { [weak self] isEnable in
            self?.setupComponentsEnable(isEnabled: isEnable)
        }, isComponentsHidden: { [weak self] isHidden in
            self?.setupComponentsHidden(isHidden: isHidden)
        }, isTableViewHidden: { [weak self] isHidden in
            self?.setupTableViewHidden(isHidden: isHidden)
        }, reloadTableView: { [weak self] in
            self?.reloadTableView()
        })
    }
    
    private func setupViews() {
        navigationItem.largeTitleDisplayMode = .never
        setupSearchButton()
        setupDescriptionLabel()
        view.layer.createGradientLayer(view: view)
        setupTableView()
        setupCarImageView()
        setupTopView()
        setupTextFields()
        setupLabels()
        scrollView.isHidden = true
        
    }
    
    private func setupTopView() {
        topView.backgroundColor = .clear
    }
    
    private func setupSearchButton() {
        searchButton.tintColor = .white
        searchButton.setTitle("Search", for: .normal)
        searchButton.backgroundColor = .searchButtonColor
        searchButton.layer.cornerRadius = 10
    }
    
    private func setupDescriptionLabel() {
        let originalFont = UIFont.systemFont(ofSize: 20.0)
        let boldFont = originalFont.bold(withSize: 20.0)
        descriptionLabel.font = boldFont
        descriptionLabel.text = "Add Your Car"
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
    }
    
    private func setupTextFields() {
        setupCurrentMilesTextField()
        setupEngineOilInputTextField()
        setupTransmissionOilInputTextField()
        setupTimingBeltInputTextField()
        setupFiltersInputTextField()
    }
    
    private func setupCurrentMilesTextField() {
        currentMilesTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter Your Milage",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        currentMilesTextField.textColor = .black
        currentMilesTextField.textAlignment = .center
        currentMilesTextField.delegate = self
        currentMilesTextField.keyboardType = .numberPad
    }
    
    private func setupEngineOilInputTextField() {
        engineOilInputTextField.attributedPlaceholder = NSAttributedString(
            string: "Last Engine Oil Milage",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        engineOilInputTextField.textColor = .black
        engineOilInputTextField.textAlignment = .center
        engineOilInputTextField.delegate = self
        engineOilInputTextField.keyboardType = .numberPad
    }
    
    private func setupTransmissionOilInputTextField() {
        transmissionOilInputTextField.attributedPlaceholder = NSAttributedString(
            string: "Last Transmission Oil Milage",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        transmissionOilInputTextField.textColor = .black
        transmissionOilInputTextField.textAlignment = .center
        transmissionOilInputTextField.delegate = self
        transmissionOilInputTextField.keyboardType = .numberPad
    }
    
    private func setupTimingBeltInputTextField() {
        timingBeltInputTextField.attributedPlaceholder = NSAttributedString(
            string: "Last Time Belt Replacement",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        timingBeltInputTextField.textColor = .black
        timingBeltInputTextField.textAlignment = .center
        timingBeltInputTextField.delegate = self
        timingBeltInputTextField.keyboardType = .numberPad
    }
    
    private func setupFiltersInputTextField() {
        filtersInputTextField.attributedPlaceholder = NSAttributedString(
            string: "Last Service Milage",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        filtersInputTextField.textColor = .black
        filtersInputTextField.textAlignment = .center
        filtersInputTextField.delegate = self
        filtersInputTextField.keyboardType = .numberPad
    }
    
    private func setupLabels() {
        setupChangeOilHelperLabel()
        setupChangeTransmissionHelperLabel()
        setupChangeTimingBeltHelperLabel()
        setupChangeFiltersHelperLabel()
    }
    
    private func setupChangeOilHelperLabel() {
        changeEngineOilHelperLabel.textColor = .white
        changeEngineOilHelperLabel.textAlignment = .center
    }
    
    private func setupChangeTransmissionHelperLabel() {
        changeTransmissionHelperLabel.textColor = .white
        changeTransmissionHelperLabel.textAlignment = .center
    }
    
    private func setupChangeTimingBeltHelperLabel() {
        timingBeltHelperLabel.textColor = .white
        timingBeltHelperLabel.textAlignment = .center
    }
    
    private func setupChangeFiltersHelperLabel() {
        changeFiltersHelperLabel.textColor = .white
        changeFiltersHelperLabel.textAlignment = .center
        changeFiltersHelperLabel.numberOfLines = 0
    }
    
    
    private func setupCarImageView() {
        carImageView.image = UIImage(named: "car")
        carImageView.backgroundColor = .clear
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
    }
    
    
    private func setupLoadingIndicator(isAnimating: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            isAnimating ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
        }
    }
    
    private func reloadTableView() {
        tableView.reloadData()
    }
    
    private func setupComponentsEnable(isEnabled: Bool) {
        DispatchQueue.main.async { [weak self] in
            if isEnabled {
                self?.searchButton.isEnabled = true
            }
        }
    }
    
    private func setupComponentsHidden(isHidden: Bool) {
        if isHidden {
            searchButton.isHidden = true
            descriptionLabel.isHidden = true
            scrollView.isHidden = false
        }
    }
    
    private func setupTableViewHidden(isHidden: Bool) {
        tableView.isHidden = isHidden
    }
    
    private func setupCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let item = viewModel.selectedCars[indexPath.section].items[indexPath.row]
        cell.textLabel?.text = item.title + " - " + item.value
        cell.textLabel?.textColor = .white
        cell.textLabel?.numberOfLines = 0
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        cell.isUserInteractionEnabled = false
        return cell
    }
    
    private func updateLabelsWhenTextFieldsAreEmpty(textField: UITextField) {
        if textField == engineOilInputTextField && textField.text?.count == 0 {
            changeEngineOilHelperLabel.text = "..."
        }
        if textField == transmissionOilInputTextField && textField.text?.count == 0 {
            changeTransmissionHelperLabel.text = "..."
        }
        if textField == filtersInputTextField && textField.text?.count == 0 {
            changeFiltersHelperLabel.text = "..."
        }
        if textField == timingBeltInputTextField && textField.text?.count == 0 {
            timingBeltHelperLabel.text = "..."
        }
    }
}

//MARK: - Actions
extension CarsDashboardViewController {
    
    private func updateEngineOilHelperLabel() {
        if let textfield = engineOilInputTextField, textfield.text!.count >= 3 {
            if let lastOilChangeInMiles = Int(engineOilInputTextField.text ?? "?") {
                changeEngineOilHelperLabel.text = viewModel.getEngineOilDescription(currentMiles: currentMiles, lastOilChangeInMiles: lastOilChangeInMiles)
            }
        }
    }
}

//MARK: - CarsListViewController Delegate
extension CarsDashboardViewController: CarsListViewControllerDelegate {
    
    func passCarDetails(car: CarsData) {
        viewModel.selectedCars.append(car)
    }
}

//MARK: - TableView Delegate
extension CarsDashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.selectedCars.isEmpty {
            return 0
        } else {
            return viewModel.selectedCars[0].items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return setupCell(tableView: tableView, indexPath: indexPath)
    }
}

//MARK: - TextField Delegate
extension CarsDashboardViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateLabelsWhenTextFieldsAreEmpty(textField: textField)
        updateEngineOilHelperLabel()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == currentMilesTextField {
            let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            engineOilInputTextField.isEnabled = !newText.isEmpty
            transmissionOilInputTextField.isEnabled = !newText.isEmpty
            filtersInputTextField.isEnabled = !newText.isEmpty
            timingBeltHelperLabel.isEnabled = !newText.isEmpty
        }
        return true
    }
}
