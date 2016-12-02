import Quick
import Nimble
@testable import Tippy
@testable import Tipout

class testWorkerViewModel: QuickSpec {
    var wasObserved = false
    
    override func spec() {
        
        describe("A WorkerViewModel") {
            var workerViewModel: WorkerViewModel!
            
            beforeEach {
                let worker = Worker(method: .Hourly(2.0), id: "0", function: { 70.0 })
                workerViewModel = WorkerViewModel(worker: worker, totalTipouts: 100)
                
                self.wasObserved = false
            }
            describe("it's percentage property") {
                it("should be observable") {
                    workerViewModel.addObserver(self, forKeyPath: "percentage", options: [.Initial, .New], context: nil)
                    expect(self.wasObserved).to(beTrue())
                }
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case "percentage"?:
            if let percentageString = change?[NSKeyValueChangeKey.newKey] as? NSAttributedString {
                debugPrint(percentageString)
                wasObserved = true
            } else { XCTFail("Unexpected type or change") }
        case nil:
            XCTFail("Unknown keypath")
        default:
            return
        }
    }
}
