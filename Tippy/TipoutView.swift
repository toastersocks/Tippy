//
//  TipoutView.swift
//  Tippy
//
//  Created by James Pamplona on 7/19/15.
//  Copyright (c) 2015 James Pamplona. All rights reserved.
//

import UIKit


/**
*  Used to notify delegates of events such as text being edited.
*/
public protocol TipoutViewDelegate {
    /**
    Tells the delegate that a text field in the `TipoutView` has been edited and resigned.
    
    - parameter tipoutView: The `TipoutView` that was edited

    */
    func tipoutViewDidEndEditing(tipoutView: TipoutView)
    
    /**
    Asks the delegate if the specified text should be changed
    
    - parameter tipoutView: The `TipoutView` containing the text field with text to be changed.
    - parameter range:      The range of characters to be replaced
    - parameter string:     The replacement string
    
    - returns: `true` if the text range should be raplaced. `false` if it should be kept the same
    
    - note: This basically forwards the respective `UITextFieldDelegate` calls
    - seeAlso: `UITextFieldDelegate`
    */
    func tipoutView(tipoutView: TipoutView, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
}

 /// A view for displaying text and receiving input concerning the tips of a worker.
@IBDesignable public class TipoutView: UIControl, UITextFieldDelegate {
    private var view: UIView!
    
    public var delegate: TipoutViewDelegate?
    
    @IBOutlet weak public var amountField: UITextField!
    @IBOutlet weak public var percentageField: UITextField!
    @IBOutlet weak public var hoursField: UITextField!
    
    @IBOutlet weak public var nameField: UITextField!
    
    /// The text field which was last edited. (Either the `amountField`, `percentageField`, or `hoursField`). Excludes `nameField`.
    public var activeTextField: UITextField? {
        didSet {
            colorFields()
        }
    }
    
     /// The text fields which have not been last edited (excluding `nameField`)
    private var inactiveFields: Set<UITextField> {
        let activeSet: Set<UITextField>
        var inactiveFields: Set<UITextField> = []
        
        if let active = activeTextField {
            activeSet = [active]
        } else {
            activeSet = []
        }
        if let amount = amountField, percentage = percentageField, hours = hoursField {
            inactiveFields = Set([amount, percentage, hours])
                .subtract(activeSet)
        }
        return inactiveFields
    }
    
    /// Indicates if the `activeTextField` should be set on text changes (`true`), or when editing is finished (`false`)
    @IBInspectable var activeOnChange: Bool = false
    
    /// Whether the text in the `inactiveFields` should be cleared when another text field becomes active.
    @IBInspectable var clearsInactiveFields: Bool = false
    
    /// The background color of the active field.
    @IBInspectable var activeColor: UIColor = .whiteColor() {
        didSet{
            activeTextField?.backgroundColor = activeColor
        }
    }
    
    /// The background color of the inactive text fields.
    @IBInspectable var inactiveColor: UIColor = .whiteColor() {
        didSet {
            colorFields()
        }
    }
    
    private func handleInputEvent(placeholderText placeholder: String?, text: String) {
        
        guard let placeholder = placeholder else { return }
            switch placeholder {
            case "Amount":
                activeTextField = amountField
            case "Percentage":
                activeTextField = percentageField
            case "Hours":
                activeTextField = hoursField
            default:
                break
            }
            if clearsInactiveFields {
                clearInactiveFields()
            }
        
    }
    
    func colorFields() {
        amountField?.backgroundColor = inactiveColor
        percentageField?.backgroundColor = inactiveColor
        hoursField?.backgroundColor = inactiveColor
        activeTextField?.backgroundColor = activeColor
    }
    
    func clearInactiveFields() {
        inactiveFields.forEach {
            $0.text = ""
        }
    }
    
    // MARK: Delegate
    
    public func textFieldDidEndEditing(textField: UITextField) {
        if !activeOnChange {
            handleInputEvent(placeholderText: textField.placeholder, text: textField.text ?? "")
            delegate?.tipoutViewDidEndEditing(self)
        }
    }
    
    public func textFieldDidBeginEditing(textField: UITextField) {
        textField.selectAll(nil)
        if textField.placeholder != "Name" {
//            textField.text = ""
        }
    }
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if activeOnChange {
//            textField.text = string
            handleInputEvent(placeholderText: textField.placeholder, text: string)
            delegate?.tipoutView(self, shouldChangeCharactersInRange: range, replacementString: string)
            
        }
        
        return true
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setup()
    }
    
    // MARK: - Setup
    
    func setup() {
        amountField.delegate = self
        percentageField.delegate = self
        hoursField.delegate = self
        nameField.delegate = self
        
        amountField.backgroundColor = inactiveColor
        percentageField.backgroundColor = inactiveColor
        hoursField.backgroundColor = inactiveColor
    }
    
    func xibSetup() {
        view = loadViewFromXib()
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromXib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let xib = UINib(nibName: "TipoutView", bundle: bundle)
        let view = xib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    // MARK: - UIView
    
    override public func didMoveToSuperview() {
        colorFields()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}