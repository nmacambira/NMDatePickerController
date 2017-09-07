# NMDatePickerController
NMDatePickerController allow users to show, on top of the actual view controller, a customized UIDatePicker with a Title label, Now, Select and Cancel buttons. Configure the DatePicker the way you want. Change the title, nowButton, selectButon and cancelButton texts.

You can customize NMDatePickerController to use blur effect.

## Screenshots

 ![Default background](https://github.com/nmacambira/NMDatePickerController/blob/master/Images/NMDatePickerController1.png)  ![Blur background](https://github.com/nmacambira/NMDatePickerController/blob/master/Images/NMDatePickerController2.png)

## Usage 

1. Add "NMDatePickerController.swift” to your project

2. Make sure you add the protocol "NMDatePickerDelegate" to the class where you want to call NMDatePickerController or you will not be able to call the delegated methods: 

    func datePickerSelectButtonAction(dateSelected: Date) 
    func datePickerCancelButtonAction()

```swift
class ViewController: UIViewController, NMDatePickerDelegate { 

   //Some code...
} 
```

3. Instatiate NMDatePickerController with its Delegate 

```swift
class ViewController: UIViewController, NMDatePickerDelegate { 

    //Some code...

    func callDatePicker(){
        let datePickerController = NMDatePickerController(delegate: self)
    }
} 
```

4. Configure DatePicker anyway you want

```swift
class ViewController: UIViewController, NMDatePickerDelegate { 

    //Some code...

    func callDatePicker(){
        let datePickerController = NMDatePickerController(delegate: self)

        datePickerController.datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        datePickerController.datePicker.locale = Locale(identifier: "en_US")
        datePickerController.datePicker.minuteInterval = 10
    }
} 
```

5. Call the delegated methods to get 'cancelButton' and 'selectButton' actions

```swift
    func datePickerCancelButtonAction() {
        print("DatePicker cancel button was pressed")
    }

    func datePickerSelectButtonAction(dateSelected: Date) {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM/dd/yyyy hh:mm a"
        let date: String = dateFormatter.string(from: dateSelected)
        print("DatePicker selected value: \(date)")
    }
```

6. [Optional] - Hide 'titleLabel' and/or 'nowButton'

```swift
    datePickerController.titleLabel.isHidden = true
    datePickerController.nowButton.isHidden = true
```

7. [Optional] - Change 'titleLabel', 'nowButton', 'selectButon' and 'cancelButton' text.

```swift
    // titleLabel default text: "Please choose the date and press 'Select' or 'Cancel'"
    datePickerController.titleLabel.text = "Please choose the date and press 'Ok' or 'Dismiss'"

    // nowButton default text: "Now"
    datePickerController.nowButton.setTitle("Right now", for: .normal)

    // cancelButton default text: "Cancel"
    datePickerController.cancelButton.setTitle("Dismiss", for: .normal)

    //selectButton default text: "Select"
    datePickerController.selectButton.setTitle("Ok", for: .normal)

```

8. [Optional] - Customize NMDatePickerController to use blur effect

```swift
    datePickerController.blurEffect = true

    // blurEffectStyle default: UIBlurEffectStyle.light
    datePickerController.blurEffectStyle = .dark
```

9. [Optional] - Preselect a date in DatePicker

```swift
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM/dd/yyyy hh:mm a"
    let label = someLabel.text
    if let date = dateFormatter.date(from: label!) {
        datePickerController.datePicker.date = date
    }
```

10. Check out the Demo Project 'NMDatePickerControllerDemo' for more insights


## License

[MIT License](https://github.com/nmacambira/NMDatePickerController/blob/master/LICENSE)

## Info

- Swift 3.1 

