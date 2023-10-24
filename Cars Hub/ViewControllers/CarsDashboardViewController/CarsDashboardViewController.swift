//
//  ViewController.swift
//  Cars Hub
//
//  Created by Pooyan J on 7/5/1402 AP.
//

import UIKit
import SDWebImage

class CarsDashboardViewController: UIViewController {
    
    @IBOutlet weak var getDetailsView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var currentMilesTextField: UITextField!
    @IBOutlet weak var engineOilInputTextField: UITextField!
    @IBOutlet weak var changeEngineOilHelperLabel: UILabel!
    @IBOutlet weak var transmissionOilInputTextField: UITextField!
    @IBOutlet weak var changeTransmissionHelperLabel: UILabel!
    @IBOutlet weak var timingBeltInputTextField: UITextField!
    @IBOutlet weak var timingBeltHelperLabel: UILabel!
    @IBOutlet weak var lastServiceMilageTextField: UITextField!
    @IBOutlet weak var nextServiceHelperLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var carImageView: UIImageView!
    @IBAction func searchButtonAction(_ sender: Any) {
        coordinator?.gotoCarsListViewController(with: viewModel.carsData, delegate: self)
    }
    
    var coordinator: MainCoordinator?
    var viewModel: CarsDashboardViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupViews()
        hideKeyboardWhenTappedAround()
    }
}

//MARK: - Setup Functions
extension CarsDashboardViewController {
    
    private func setupViewModel() {
        viewModel = CarsDashboardViewModel(showLoading: { [weak self] isAnimating in
            self?.setupLoadingIndicator(isAnimating: isAnimating)
        }, isSearchButtonEnable: { [weak self] isEnable in
            self?.setupSearchButtonEnable(isEnabled: isEnable)
        }, isTableViewHidden: { [weak self] isHidden in
            self?.hideDetailsPage(isHidden: isHidden)
        }, isScrollViewHidden: { [weak self] isHidden in
            self?.setupScrollViewHidden(isHidden: isHidden)
        }, isInitialViewHidden: { [weak self] isHidden in
            self?.setupInitialViewHidden(isHidden: isHidden)
        }, reloadTableView: { [weak self] in
            self?.reloadTableView()
        }, updateTimingBeltReplacement: { [weak self] text in
            self?.updateTimingBeltReplacementHelperLabel(text: text)
        }, updateEngineOilMilageText: { [weak self] text in
            self?.updateEngineOilHelperLabel(text: text)
        }, updateTransmissionOilMilageText: { [weak self] text in
            self?.updateTransmissionOilHelperLabel(text: text)
        }, updateNextServiceMilageText: { [weak self] text in
            self?.updateNextServiceHelperLabel(text: text)
        }, showBanner: { [weak self] text in
            self?.showBanner(text: text)
        })
    }
    
    private func setupViews() {
        setupSegmentControl()
        setupScrollView()
        navigationItem.largeTitleDisplayMode = .never
        setupSearchButton()
        setupDescriptionLabel()
        view.layer.createGradientLayer(view: view)
        setupTableView()
        setupCarImageView()
        setupTopView()
        setupTextFields()
        setupLabels()
    }
    
    private func setupSegmentControl() {
        segmentControl.setTitle("Personal Service", forSegmentAt: 0)
        segmentControl.setTitle("Car Data ", forSegmentAt: 1)
        segmentControl.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
        segmentControl.isHidden = DataManager.shared.loadCarDetails() == nil
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.isHidden = DataManager.shared.loadCarDetails() == nil
    }
    
    private func setupScrollViewHidden(isHidden: Bool) {
        scrollView.isHidden = isHidden
    }
    
    private func setupTopView() {
        parentView.backgroundColor = .clear
    }
    
    private func setupSearchButton() {
        searchButton.tintColor = .white
        searchButton.setTitle("Search", for: .normal)
        searchButton.backgroundColor = .searchButtonColor
        searchButton.layer.cornerRadius = 10
        searchButton.isHidden = DataManager.shared.loadCarDetails() != nil
    }
    
    private func setupDescriptionLabel() {
        let originalFont = UIFont.systemFont(ofSize: 20.0)
        let boldFont = originalFont.bold(withSize: 20.0)
        descriptionLabel.font = boldFont
        descriptionLabel.text = "Add Your Car"
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
        descriptionLabel.isHidden = DataManager.shared.loadCarDetails() != nil
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
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        currentMilesTextField.textColor = .white
        currentMilesTextField.layer.borderWidth = 1
        currentMilesTextField.layer.borderColor = UIColor.white.cgColor
        currentMilesTextField.textAlignment = .center
        currentMilesTextField.delegate = self
        currentMilesTextField.keyboardType = .numberPad
        currentMilesTextField.backgroundColor = .clear
        currentMilesTextField.layer.cornerRadius = 16
    }
    
    private func setupEngineOilInputTextField() {
        engineOilInputTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter Milage Here",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        engineOilInputTextField.textColor = .white
        engineOilInputTextField.layer.borderWidth = 1
        engineOilInputTextField.layer.borderColor = UIColor.white.cgColor
        engineOilInputTextField.textAlignment = .center
        engineOilInputTextField.delegate = self
        engineOilInputTextField.keyboardType = .numberPad
        engineOilInputTextField.backgroundColor = .clear
        engineOilInputTextField.layer.cornerRadius = 16
    }
    
    private func setupTransmissionOilInputTextField() {
        transmissionOilInputTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter Milage Here",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        transmissionOilInputTextField.textColor = .white
        transmissionOilInputTextField.layer.borderWidth = 1
        transmissionOilInputTextField.layer.borderColor = UIColor.white.cgColor
        transmissionOilInputTextField.textAlignment = .center
        transmissionOilInputTextField.delegate = self
        transmissionOilInputTextField.keyboardType = .numberPad
        transmissionOilInputTextField.backgroundColor = .clear
        transmissionOilInputTextField.layer.cornerRadius = 16
    }
    
    private func setupTimingBeltInputTextField() {
        timingBeltInputTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter Milage Here",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        timingBeltInputTextField.textColor = .white
        timingBeltInputTextField.layer.borderWidth = 1
        timingBeltInputTextField.layer.borderColor = UIColor.white.cgColor
        timingBeltInputTextField.textAlignment = .center
        timingBeltInputTextField.delegate = self
        timingBeltInputTextField.keyboardType = .numberPad
        timingBeltInputTextField.backgroundColor = .clear
        timingBeltInputTextField.layer.cornerRadius = 16
    }
    
    private func setupFiltersInputTextField() {
        lastServiceMilageTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter Milage Here",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        lastServiceMilageTextField.textColor = .white
        lastServiceMilageTextField.layer.borderWidth = 1
        lastServiceMilageTextField.layer.borderColor = UIColor.white.cgColor
        lastServiceMilageTextField.textAlignment = .center
        lastServiceMilageTextField.delegate = self
        lastServiceMilageTextField.keyboardType = .numberPad
        lastServiceMilageTextField.backgroundColor = .clear
        lastServiceMilageTextField.layer.cornerRadius = 16
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
        nextServiceHelperLabel.textColor = .white
        nextServiceHelperLabel.textAlignment = .center
        nextServiceHelperLabel.numberOfLines = 0
    }
    
    
    private func setupCarImageView() {
        carImageView.image = UIImage(named: "car")
        carImageView.alpha = 0.25
        carImageView.backgroundColor = .clear
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
    }
    
    
    private func setupLoadingIndicator(isAnimating: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            isAnimating ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
        }
    }
    
    @objc func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            scrollView.contentOffset.x = view.bounds.minX
        case 1:
            scrollView.contentOffset.x = view.bounds.maxX
        default:
            print("def")
        }
    }
    
    private func reloadTableView() {
        tableView.reloadData()
    }
    
    private func setupSearchButtonEnable(isEnabled: Bool) {
        searchButton.isEnabled = isEnabled
    }
    
    private func setupInitialViewHidden(isHidden: Bool) {
        if isHidden {
            searchButton.isHidden = true
            descriptionLabel.isHidden = true
        }
    }
    
    private func hideDetailsPage(isHidden: Bool) {
        
    }
        
    private func setupCell(carData: (title: String, value: String)) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = carData.title + " - " + carData.value
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
        if textField == lastServiceMilageTextField && textField.text?.count == 0 {
            nextServiceHelperLabel.text = "..."
        }
        if textField == timingBeltInputTextField && textField.text?.count == 0 {
            timingBeltHelperLabel.text = "..."
        }
    }
}

//MARK: - Actions
extension CarsDashboardViewController {
        
    private func updateEngineOilHelperLabel(text: String) {
        changeEngineOilHelperLabel.text = text
    }
    
    private func updateTransmissionOilHelperLabel(text: String) {
        changeTransmissionHelperLabel.text = text
    }
    
    private func updateTimingBeltReplacementHelperLabel(text: String) {
        timingBeltHelperLabel.text = text
    }
    
    private func updateNextServiceHelperLabel(text: String) {
        nextServiceHelperLabel.text = text
    }
    
    private func updateFiltersReplacementHelper() {
        if let textfield = lastServiceMilageTextField, textfield.text!.count >= 3 {
            if let lastOilChangesInMiles = Int(lastServiceMilageTextField.text ?? "?") {
                nextServiceHelperLabel.text = viewModel.getNextServiceDescription(currentMiles: viewModel.currentMiles, lastOIlChangeInMiles: lastOilChangesInMiles)
            }
        }
    }
    
    private func showBanner(text: String) {
        CustomBannerManager.shared.showBanner(message: text, inView: view)
    }
}

//MARK: - CarsListViewController Delegate
extension CarsDashboardViewController: CarsListViewControllerDelegate {
    
    func passCarDetails(car: CarData) {
        viewModel.selectedCars.append(car)
    }
}

//MARK: - TableView Delegate
extension CarsDashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if DataManager.shared.loadCarDetails() == nil {
            if viewModel.selectedCars.isEmpty {
                return 0
            } else {
                return viewModel.selectedCars[0].items.count
            }
        } else {
            return DataManager.shared.loadCarDetails()?.carInfo?.items.count ?? 0
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let item = viewModel.getItem() {
            return setupCell(carData: item.items[indexPath.row])
        }
        return UITableViewCell()
    }
}

//MARK: - TextField Delegate
extension CarsDashboardViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.timeBeltText = timingBeltInputTextField.text!
        viewModel.engineOilMilageText = engineOilInputTextField.text!
        viewModel.currentMilageText = currentMilesTextField.text!
        viewModel.transmissionOilMilageText = transmissionOilInputTextField.text!
        viewModel.lastServiceMilageText = lastServiceMilageTextField.text!
        viewModel.updateSummaryLabel()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == currentMilesTextField {
            let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            engineOilInputTextField.isEnabled = !newText.isEmpty
            transmissionOilInputTextField.isEnabled = !newText.isEmpty
            lastServiceMilageTextField.isEnabled = !newText.isEmpty
            timingBeltHelperLabel.isEnabled = !newText.isEmpty
        }
        return true
    }
}

//MARK: - ScrollView Delegate
extension CarsDashboardViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != tableView {
            if scrollView.contentOffset.x < view.center.x {
                if segmentControl.selectedSegmentIndex != 0 {
                    segmentControl.selectedSegmentIndex = 0
                }
            } else {
                if segmentControl.selectedSegmentIndex != 1 {
                    segmentControl.selectedSegmentIndex = 1
                }
            }
        }
    }
}
