import XCTest
import RealmSwift
import ExpensesBy2

class BalanceTests: XCTestCase {
    
    // MARK: Constants
    let value = 12.34
    let person1Name = k.Person1Name
    let person2Name = k.Person2Name
    
    // MARK: SetUp
    override func setUp() {
        RealmUtilities.deleteAllEntries()
    }
    
    // MARK: Total Tests For In Common Expenses
    func testTotalForEmptyEntries() {
        XCTAssertEqual(0.0, Balance.total())
    }
    
    func testTotalOneEntryForPerson1() {
        RealmUtilities.addEntryWithAmount(value)
        XCTAssertEqual(value/2, Balance.total())
    }
    
    func testTwoEntriesGivesSumAmountBalance() {
        RealmUtilities.addEntryWithAmount(value)
        RealmUtilities.addEntryWithAmount(value)
        XCTAssertEqual((value+value)/2, Balance.total())
    }
    
    func testTwoEqualEntriesFromDifferentPersonsGivesZeroBalance() {
        RealmUtilities.addEntryWithAmount(value)
        RealmUtilities.addEntryWithAmount(value,PaidBy:1)
        XCTAssertEqual(0.0, Balance.total())
    }
    
    func testSomeEntriesFromDifferentPersonsGivesCorrectBalance() {
        RealmUtilities.addEntryWithAmount(value)
        RealmUtilities.addEntryWithAmount(value)
        RealmUtilities.addEntryWithAmount(value,PaidBy:1)
        XCTAssertEqual(value/2, Balance.total())
        RealmUtilities.addEntryWithAmount(value,PaidBy:1)
        XCTAssertEqual(0.0, Balance.total())
        RealmUtilities.addEntryWithAmount(value,PaidBy:1)
        XCTAssertEqual(-value/2, Balance.total())
    }
    
    // MARK: Total Tests For Not In Common Expenses
    func testTotalOneEntryForPerson1ToPerson2() {
        RealmUtilities.addEntryWithAmount(value, PaidBy: 0, PaidTo: 1)
        XCTAssertEqual(value, Balance.total())
    }
    
    func testTotalOneEntryForPerson2ToPerson1() {
        RealmUtilities.addEntryWithAmount(value, PaidBy: 1, PaidTo: 0)
        XCTAssertEqual(-value, Balance.total())
    }
    
    func testTotalOneEntryForPerson1ToPerson1() {
        RealmUtilities.addEntryWithAmount(value, PaidBy: 0, PaidTo: 0)
        XCTAssertEqual(0.0, Balance.total())
    }
    
    func testTotalOneEntryForPerson2ToPerson2() {
        RealmUtilities.addEntryWithAmount(value, PaidBy: 1, PaidTo: 1)
        XCTAssertEqual(0.0, Balance.total())
    }
    
    func testSomeEntriesFromDifferentPersonsBetweenThemselvesGivesCorrectBalance() {
        RealmUtilities.addEntryWithAmount(value, PaidBy: 0)
        RealmUtilities.addEntryWithAmount(value, PaidBy: 0, PaidTo: 0)
        RealmUtilities.addEntryWithAmount(value, PaidBy: 0, PaidTo: 1)
        XCTAssertEqual(value + value/2, Balance.total())
    }
    
    // MARK: Summary Tests
    func testSummaryForEmptyEntries(){
        XCTAssertEqual("zero_balance".localized, Balance.summary())
    }
    
    func testSummaryOneEntryForPerson1() {
        RealmUtilities.addEntryWithAmount(value)
        let summary = person2Name + " owes " + person1Name + " " + "\(value/2)" + "€"
        XCTAssertEqual(summary, Balance.summary())
    }
    
    func testTwoEntriesGivesSummary() {
        RealmUtilities.addEntryWithAmount(value)
        RealmUtilities.addEntryWithAmount(value)
        let summary = person2Name + " owes " + person1Name + " " + "\((value+value)/2)" + "€"
        XCTAssertEqual(summary, Balance.summary())
    }
    
    func testTwoEqualEntriesFromDifferentPersonsGivesSummary() {
        RealmUtilities.addEntryWithAmount(value)
        RealmUtilities.addEntryWithAmount(value,PaidBy:1)
        XCTAssertEqual("zero_balance".localized, Balance.summary())
    }
    
    func testSomeEntriesFromDifferentPersonsGivesSummary() {
        RealmUtilities.addEntryWithAmount(value)
        RealmUtilities.addEntryWithAmount(value)
        RealmUtilities.addEntryWithAmount(value,PaidBy:1)
        var summary = person2Name + " owes " + person1Name + " " + "\(value/2)" + "€"
        XCTAssertEqual(summary, Balance.summary())
        RealmUtilities.addEntryWithAmount(value,PaidBy:1)
        XCTAssertEqual("zero_balance".localized, Balance.summary())
        RealmUtilities.addEntryWithAmount(value,PaidBy:1)
        summary = person1Name + " owes " + person2Name + " " + "\(value/2)" + "€"
        XCTAssertEqual(summary, Balance.summary())
    }
    
    // MARK: Totals Formatted Tests
    func testBalanceTotalFormatted(){
        XCTAssertEqual("0.00€", Balance.total().currency)
        RealmUtilities.addEntryWithAmount(2.0)
        XCTAssertEqual("1.00€", Balance.total().currency)
    }
}