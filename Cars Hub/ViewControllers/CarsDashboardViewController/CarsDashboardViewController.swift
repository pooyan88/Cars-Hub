//
//  ViewController.swift
//  Cars Hub
//
//  Created by Pooyan J on 7/5/1402 AP.
//

import UIKit
import SDWebImage

final class CarsDashboardViewController: UIViewController {
    
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
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var carImageView: UIImageView!

    private var viewModel: CarsDashboardViewModel!
    var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        hideKeyboardWhenTappedAround()
        viewModel.setupNavigationItemTitle()
        viewModel.setupSegmentControlHidden()
        showSaveGuideAlert()
    }
}

//MARK: - Setup Functions
extension CarsDashboardViewController {
    
    func configViewModel(car: CarData) {
        setupViewModel(car: car)
    }
    
    private func setupViewModel(car: CarData) {
        viewModel = CarsDashboardViewModel(car: car, 
            setupSegmentControlHiddenStyle: { [weak self] isHidden in
            self?.setupSegmentControlHiddenStyle(isHidden: isHidden)
        }, setupScrollViewHiddenStyle: { [weak self] isHidden in
            self?.setupScrollViewHidden(isHidden: isHidden)
        },  reloadTableView: { [weak self] in
            self?.reloadTableView()
        }, updateTimingBeltReplacementDescription: { [weak self] text in
            self?.updateTimingBeltReplacementHelperLabel(text: text)
        }, updateEngineOilChangeDescription: { [weak self] text in
            self?.updateEngineOilHelperLabel(text: text)
        }, updateTransmissionOilChangeDescription: { [weak self] text in
            self?.updateTransmissionOilHelperLabel(text: text)
        }, updateNextServiceDescription: { [weak self] text in
            self?.updateNextServiceHelperLabel(text: text)
        }, setupNavigationBarTitle: { [weak self] text in
            self?.setupNavigationBarTitle(text: text)
        }, showBanner: { [weak self] text in
            self?.showBanner(text: text)
        })
    }
    
    private func setupViews() {
        setupSegmentControl()
        setupScrollView()
        navigationItem.largeTitleDisplayMode = .never
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
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
    }
    
    private func setupScrollViewHidden(isHidden: Bool) {
        scrollView.isHidden = isHidden
    }
    
    private func setupTopView() {
        parentView.backgroundColor = .clear
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
        currentMilesTextField.text = viewModel.car.userCarDetails?.currentMilage
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
        engineOilInputTextField.text = viewModel.car.userCarDetails?.lastEngineOilChangeMilage
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
        transmissionOilInputTextField.text = viewModel.car.userCarDetails?.lastTransmissionMilage
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
        timingBeltInputTextField.text = viewModel.car.userCarDetails?.lastTimingBeltReplacementMilage
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
        lastServiceMilageTextField.text = viewModel.car.userCarDetails?.lastServiceMilage
    }
    
    private func setupLabels() {
        setupChangeOilHelperLabel()
        setupChangeTransmissionHelperLabel()
        setupChangeTimingBeltHelperLabel()
        setupNextServiceHelperLabel()
    }
    
    private func setupChangeOilHelperLabel() {
        changeEngineOilHelperLabel.textColor = .white
        changeEngineOilHelperLabel.textAlignment = .left
        changeEngineOilHelperLabel.text = viewModel.car.userCarDetails?.engineOilHelperDescription ?? "..."
    }
    
    private func setupChangeTransmissionHelperLabel() {
        changeTransmissionHelperLabel.textColor = .white
        changeTransmissionHelperLabel.textAlignment = .left
        changeTransmissionHelperLabel.text = viewModel.car.userCarDetails?.transmissionOilHelperDescription ?? "..."
    }
    
    private func setupChangeTimingBeltHelperLabel() {
        timingBeltHelperLabel.textColor = .white
        timingBeltHelperLabel.textAlignment = .left
        timingBeltHelperLabel.text = viewModel.car.userCarDetails?.timingBeltReplacementHelperDescription ?? "..."
    }
    
    private func setupNextServiceHelperLabel() {
        nextServiceHelperLabel.textColor = .white
        nextServiceHelperLabel.textAlignment = .left
        nextServiceHelperLabel.numberOfLines = 0
        nextServiceHelperLabel.text = viewModel.car.userCarDetails?.nextServiceHelperDescription ?? "..."
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
    
    @objc func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self else { return }
                scrollView.contentOffset.x = view.bounds.minX
            }
        case 1:
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self else { return }
                scrollView.contentOffset.x = view.bounds.maxX
            }
        default:
            print("def")
        }
    }
    
    private func reloadTableView() {
        tableView.reloadData()
    }
    
    private func setupSegmentControlHiddenStyle(isHidden: Bool) {
        segmentControl.isHidden = isHidden
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
    
    private func showSaveGuideAlert() {
        if let text = lastServiceMilageTextField.text, text.isEmpty {
            AlertManager.shared.showAlert(alertTitle: "Warning", alertDescription: "To save your information, you must fill all of the required fields", alertConfirmationButtonTitle: "OK", view: self)
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
    
    private func showBanner(text: String) {
        CustomBannerManager.shared.showBanner(message: text, inView: view.window!)
    }
    
    private func setupNavigationBarTitle(text: String) {
        navigationItem.title = text
    }
}

//MARK: - TableView Delegate
extension CarsDashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.car.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return setupCell(carData: viewModel.car.items[indexPath.row])
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
        viewModel.setData()
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
