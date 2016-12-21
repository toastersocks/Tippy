import Quick
import Nimble
@ testable import Tippy

class testTextValidator: QuickSpec {
    override func spec() {
        describe("a Validator") {
            var validator: Validator! = nil
            var isTextValid: Bool!
            beforeEach {
                validator = Formatter()
            }
            
            it("should return true if the given currency text is valid") {
                isTextValid = validator.isCurrencyTextValid(text: "56.0")
                expect(isTextValid).to(beTrue())
            }
            
            it("should return false if the given currency text is invalid") {
                isTextValid = validator.isCurrencyTextValid(text: "a")
                expect(isTextValid).to(beFalse())
            }
            
            it("should return true if the given percentage text is valid") {
                isTextValid = validator.isPercentageTextValid(text: "56")
                expect(isTextValid).to(beTrue())
            }
            
            it("should return false if the given percentage text is invalid") {
                isTextValid = validator.isPercentageTextValid(text: "a")
                expect(isTextValid).to(beFalse())
            }
            
            it("should return true if the given hours text is valid") {
                isTextValid = validator.isHoursTextValid(text: "56.0")
                expect(isTextValid).to(beTrue())
            }
            
            it("should return false if the given hours text is invalid") {
                isTextValid = validator.isHoursTextValid(text: "56.0.2")
                expect(isTextValid).to(beFalse())
            }

        }
    }
}
