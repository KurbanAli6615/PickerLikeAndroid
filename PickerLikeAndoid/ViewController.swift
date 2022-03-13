//
//  ViewController.swift
//  PickerLikeAndoid
//
//  Created by KurbanAli on 12/03/22.
//

import UIKit
import SnapKit

enum SelectedPickerType {
    case YEAR
    case DATE
}
extension Date {
    
    func getDaysInMonth() -> Int{
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func formatDateToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: self)
    }
    
}

extension ViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Selected Year",pickerData[row])
        self.buttonYear.setTitleColor(.white.withAlphaComponent(0.5), for: .normal)
        self.dateButton.setTitleColor(.white, for: .normal)
        self.selectedType = SelectedPickerType.DATE
        self.buttonYear.setTitle(pickerData[row], for: .normal)
        self.yearPickerView.isHidden = true
    }
}

class ViewController: UIViewController {
    
    let daysArr:[String] = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
    var pickerData: [String] {
        var arr: [String] = []
        for i in 1900...2100 {
            arr.append(String(format: "%d", i))
        }
        return arr
    }
    
    var selectedCell: Int = 17
    
    private var selectedType: SelectedPickerType = SelectedPickerType.DATE

    var dateCounter: Int = 01
    var maxDays: Int {
        return Date().getDaysInMonth()
    }
    var startDay: String = ""
    var endDay: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startDay = Date().startOfMonth().formatDateToString()
        endDay = Date().endOfMonth().formatDateToString()

        
        backViewSetUp()
        setUpDateYearView()
        makeLabelsInDateView()
        
        makePrevNextButton()
        setTheCurrentMonthYear()
        makeCollectionView()
        makeOkCacelButton()
        makeYearPickerView()
        
        buttonYear.addTarget(self, action: #selector(didYearTapped(_:)), for: .touchUpInside)
        dateButton.addTarget(self, action: #selector(didDateTapped(_:)), for: .touchUpInside)
        prevButton.addTarget(self, action: #selector(didPrevTapped(_:)), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didNextTapped(_:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(didCancelTappped(_:)), for: .touchUpInside)
        okButton.addTarget(self, action: #selector(didOktapped(_:)), for: .touchUpInside)
    }
    
    //  MARK: - IBACTIONS & LOGICS
    
    @objc func didYearTapped(_ sender: UIButton) {
        print("Year Taaped")
        if selectedType != SelectedPickerType.YEAR {
            dateButton.setTitleColor(.white.withAlphaComponent(0.5), for: .normal)
            buttonYear.setTitleColor(.white, for: .normal)
            selectedType = SelectedPickerType.YEAR
            if let indexPosition = pickerData.firstIndex(of: buttonYear.titleLabel?.text ?? ""){
              yearPicker.selectRow(indexPosition, inComponent: 0, animated: true)
            }
            self.yearPickerView.isHidden = false
        }
    }
    
    @objc func didDateTapped(_ sender: UIButton) {
        print("Date Taaped")
        if selectedType != SelectedPickerType.DATE {
            buttonYear.setTitleColor(.white.withAlphaComponent(0.5), for: .normal)
            dateButton.setTitleColor(.white, for: .normal)
            selectedType = SelectedPickerType.DATE
            self.yearPickerView.isHidden = true
        }
    }
    
    @objc func didPrevTapped(_ sender: UIButton) {
        print("Prev Tapped")
    }
    
    @objc func didNextTapped(_ sender: UIButton) {
        print("Next Tapped")
    }
    
    @objc func didCancelTappped(_ sender: UIButton) {
        print("Cancel Tapped")
    }
    
    @objc func didOktapped(_ sender: UIButton) {
        print("Ok Tapped")
        let cell = datesCollectionView.cellForItem(at: [0,selectedCell]) as! DateCell
        print(cell.dateLabel.text ?? "")
    }
    
    //  MARK: - BackView
    
    private lazy var backViewOfPicker = UIView()
    private lazy var dateYearView = UIView()
    
    private func backViewSetUp() {
        self.view.addSubview(backViewOfPicker)
        backViewOfPicker.backgroundColor = .white
        backViewOfPicker.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view).multipliedBy(0.8)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view)
        }
        backViewOfPicker.layer.cornerRadius = 5
        backViewOfPicker.layer.shadowOffset = CGSize(width: 0, height: 0)
        backViewOfPicker.layer.shadowRadius = 20
        backViewOfPicker.layer.shadowOpacity = 0.3
        backViewOfPicker.layer.shadowColor = UIColor.black.cgColor
    }
    
    private func setUpDateYearView() {
        self.backViewOfPicker.addSubview(dateYearView)
        dateYearView.backgroundColor = .systemBlue
        dateYearView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }
        dateYearView.clipsToBounds = true
        dateYearView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var buttonYear = UIButton()
    private lazy var dateButton = UIButton()
    
    private func makeLabelsInDateView() {
        
        buttonYear.setTitleColor(.white.withAlphaComponent(0.5), for: .normal)
        dateButton.setTitleColor(.white, for: .normal)
        
        dateYearView.addSubview(buttonYear)
        buttonYear.setTitle("2022", for: .normal)
        buttonYear.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.top.equalToSuperview().inset(10)
        }
        
        dateYearView.addSubview(dateButton)
        dateButton.setTitle("Sat, Mar 12", for: .normal)
        dateButton.snp.makeConstraints { make in
            make.leading.equalTo(buttonYear)
            make.topMargin.equalTo(buttonYear.snp.bottom).inset(-5)
            make.bottom.equalToSuperview().inset(10)
        }
        dateButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
    }
    
    //  MARK: - prevNextView
    
    private lazy var prevNextView = UIView()
    
    private func makePrevNextButton() {
        backViewOfPicker.addSubview(prevNextView)
        prevNextView.backgroundColor = .clear
        prevNextView.snp.makeConstraints { make in
            make.topMargin.equalTo(dateYearView.snp.bottom).offset(20)
            make.height.equalTo(50)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
        }
    }
    
    private lazy var prevButton = UIButton()
    private lazy var nextButton = UIButton()
    private lazy var currentMonthLabel = UILabel()
    
    private func setTheCurrentMonthYear() {
        prevNextView.addSubview(prevButton)
        prevButton.setImage(Images.prevButton, for: .normal)
        prevButton.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(20)
            make.leading.equalTo(10)
            make.centerY.equalTo(prevNextView.snp.centerY)
        }
        
        prevNextView.addSubview(nextButton)
        nextButton.setImage(Images.nextButton, for: .normal)
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(20)
            make.trailing.equalTo(-10)
            make.centerY.equalTo(prevNextView.snp.centerY)
        }
        
        currentMonthLabel.text = "March 2022"
        currentMonthLabel.textAlignment = .center
        prevNextView.addSubview(currentMonthLabel)
        currentMonthLabel.snp.makeConstraints { make in
            make.leading.equalTo(prevButton.snp.trailing).offset(10)
            make.trailing.equalTo(nextButton.snp.leading).offset(-10)
            make.centerY.equalTo(prevNextView.snp.centerY)
        }
        
    }
    
    
    //  MARK: - CollectionView
    
    private var datesCollectionView: UICollectionView!
    
    private func makeCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        datesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        datesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        datesCollectionView.dataSource = self
        datesCollectionView.delegate = self
        datesCollectionView.register(DateCell.self, forCellWithReuseIdentifier: "DateCell")
        backViewOfPicker.addSubview(datesCollectionView)
        datesCollectionView.snp.remakeConstraints { make in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.top.equalTo(prevNextView.snp.bottom).offset(5)
            make.height.equalTo((((((self.view.frame.width * 0.8) - 20) / 7 )) * 6) + 10)
        }
    }
    
    //  MARK: - OK Cancel Button
    private var okCancelView = UIView()
    private var okButton = UIButton()
    private var cancelButton = UIButton()
    
    private func makeOkCacelButton() {
        backViewOfPicker.addSubview(okCancelView)
        okCancelView.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.top.equalTo(datesCollectionView.snp.bottom).offset(25)
            make.bottom.equalTo(-10)
            make.height.equalTo(50)
        }
        
        okCancelView.addSubview(okButton)
        okButton.setTitle("OK", for: .normal)
        okButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        okButton.setTitleColor(.systemBlue, for: .normal)
        okButton.snp.makeConstraints { make in
            make.trailing.equalTo(-30)
            make.bottom.equalTo(-10)
        }
        
        okCancelView.addSubview(cancelButton)
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancelButton.setTitleColor(.systemBlue, for: .normal)
        cancelButton.snp.makeConstraints { make in
            make.trailing.equalTo(okButton.snp.leading).offset(-30)
            make.bottom.equalTo(-10)
        }
    }
    
    //  MARK: - YearPicker
        
    private var yearPickerView = UIView()
    private var yearPicker = UIPickerView()
    
    private func makeYearPickerView() {
        yearPickerView.isHidden = true
        
        backViewOfPicker.addSubview(yearPickerView)
        yearPickerView.backgroundColor = .white
        yearPickerView.snp.makeConstraints { make in
            make.leading.equalTo(00)
            make.trailing.equalTo(0)
            make.top.equalTo(dateYearView.snp.bottom)
            make.bottom.equalTo(okCancelView.snp.top)
        }
        
        yearPicker.dataSource = self
        yearPicker.delegate = self
        yearPickerView.addSubview(yearPicker)
        yearPicker.snp.makeConstraints { make in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = datesCollectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        
        if indexPath.row <= 6 {
            if let ch = daysArr[indexPath.row].first {
                cell.dateLabel.text = String(ch)
            }
            cell.makeViewOfCell(colored: indexPath.row == selectedCell, height: (((self.view.frame.width * 0.8) - 20) / 7 ), lightTextColor: true)
            
        } else if indexPath.row > 6 {
            if (startDay == "" && dateCounter <= maxDays) || (startDay == daysArr[indexPath.row % 7] && dateCounter <= maxDays) {
                cell.dateLabel.text = String(format: "%d", dateCounter)
                cell.makeViewOfCell(colored: indexPath.row == selectedCell, height: (((self.view.frame.width * 0.8) - 20) / 7 ), lightTextColor: false)
                startDay = ""
                dateCounter += 1
            } else {
                cell.dateLabel.text = ""
                cell.makeViewOfCell(colored: indexPath.row == selectedCell, height: (((self.view.frame.width * 0.8) - 20) / 7 ), lightTextColor: false)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (((self.view.frame.width * 0.8) - 20) / 7 ), height: (((self.view.frame.width * 0.8) - 20) / 7 ))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DateCell
        if cell.dateLabel.text != "" {
            if indexPath.row > 6 {
                selectedCell = indexPath.row
                startDay = Date().startOfMonth().formatDateToString()
                endDay = Date().endOfMonth().formatDateToString()
                dateCounter = 01
                collectionView.reloadData()
            }
        }
    }
}

class DateCell: UICollectionViewCell {
    
    var mainView = UIView()
    var dateLabel = UILabel()
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func makeViewOfCell(colored: Bool, height: CGFloat, lightTextColor: Bool) {
        mainView.backgroundColor = colored ? .systemBlue : .clear
        contentView.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.leading.equalTo(5)
            make.trailing.equalTo(5)
            make.top.equalTo(5)
            make.bottom.equalTo(5)
        }
        
        mainView.layer.cornerRadius = (height) / 2
        mainView.addSubview(dateLabel)
        dateLabel.textColor = colored ? .white : lightTextColor ? .lightGray : .black
        dateLabel.font = UIFont.systemFont(ofSize: 15)
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(mainView.snp.centerY)
            make.centerX.equalTo(mainView.snp.centerX)
        }
        
    }
}
