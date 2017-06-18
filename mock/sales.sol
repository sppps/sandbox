/*
SECURED INTERNATIONAL SALE OF GOODS SMART CONTRACT

This agreement for the sale of goods is entered between the Seller (“<enter address public seller>”) and Buyer (“<enter address public buyer>”).

The parties agree as follows:

1. Sale of Goods. The Seller shall sell to the Buyer and the Buyer shall purchase from the Seller the goods in the quantities and at the prices as set forth in IPFS: <enter hash>.

2. Deposit. Each party shall transmit funds to <enter contract address> in the amount of the price of the goods and a security deposit that is equal to the value of the goods. The Seller may cancel this agreement before a deposit is made by the Buyer and receive paid in funds back. Once a deposit by the Buyer is made, the funds shall be locked in the contract’s wallet.

3. Delivery; Title; and Risk of Loss. The Seller shall deliver the goods under Incoterms 2010 <enter delivery term>.

4. Payment. Upon delivery of the goods, the Buyer shall execute the function to release the locked funds from the contract’s wallet. The Seller shall receive the price of the goods and Seller’s portion of the security deposit. The Buyer shall receive the Buyer’s portion of the security deposit.

5. Limitation of Liability. The Seller shall not be liable for any indirect, special, consequential, or punitive damages (including lost profits) arising out of or relating to this agreement, whether for breach of contract, tort, negligence, or any other form of action. In no event shall the Seller’s liability exceed the price the Buyer paid for the specific goods provided by the Seller giving rise to the claim or cause of action.

6. Force Majeure. The Seller shall not be held liable for delays in performance or for non-performance due to unforeseen circumstances or causes beyond the Seller’s reasonable control.

7. Plain Text. This plain text version of the agreement supersedes any other rules, electronic logic, code, programs, or software representations of the terms and conditions found herein.

8. Governing Law. The governing law for the agreement shall be the UNIDROIT Principles (2010) and, with respect to issues not covered by such Principles, by generally accepted principles of international commercial law.

9. Dispute Resolution. Any dispute arising out of or in connection with this agreement shall be referred to and finally resolved by arbitration under the latest version of the Arbitracio Rules found at https://github.com/alvinjoelsantos/arbitracio, which Rules are deemed to be incorporated by reference. The parties agree that the arbitration shall be conducted with the use of electronic documents only and that the arbitral tribunal may limit the number, length, and scope of written submissions and written witness evidence. The arbitral tribunal may directly enforce any award by executing functions from the arbitrator’s wallet (“enter address public arbitrator”) to release funds to the respective parties in accordance with such award. To initiate the arbitration process either party may submit 2 ether to the contract’s wallet, which will lock the funds until the dispute is resolved. The arbitration fee is set to 2 ether and shall be equally split between the Seller and Buyer. On distribution of funds, the arbitrator may deduct the arbitration fee from the security deposit.

10. Electronic Signatures. This agreement is signed electronically by the parties and recorded on <enter blockchain and transaction hash>.
*/

pragma solidity ^0.4.11;

contract Sales {
    uint public value;
    bytes32 public pid = 4b57c7141cf17c97f76ab9c5f6bdbfb3a5e92078fb8657a594581a9977c50b92;
    address public seller;
    address public buyer;
    address public arbitrator;
    enum State { Created, Locked, Inactive }
    State public state;

    function Purchase() payable {
        seller = msg.sender;
        value = msg.value / 2;
        require((2 * value) == msg.value);
    }

    modifier condition(bool _condition) {
        require(_condition);
        _;
    }

    modifier onlyBuyer() {
        require(msg.sender == buyer);
        _;
    }

    modifier onlySeller() {
        require(msg.sender == seller);
        _;
    }

    modifier onlyArbitrator() {
        require(msg.sender == arbitrator);
        _;
    }

    modifier inState(State _state) {
        require(state == _state);
        _;
    }

    event Revoked();
    event Accepted();
    event GoodsReceived();
    event Disputed();
    event Resolved();
    event Terminated();

    /// Seller can revoke the offer and recover deposit before Buyer's acceptance.
    function revoke()
        onlySeller
        inState(State.Created)
    {
        Revoked();
        state = State.Inactive;
        seller.transfer(this.balance);
    }

    /// Buyer submits deposit to accept Seller's offer, which lock funds until Seller's performance. Buyer's deposit is twice the value of the goods.
    function acceptOffer()
    function accept()        
        inState(State.Created)
        condition(msg.value == (2 * value))
        payable
    {
        Accepted();
        buyer = msg.sender;
        state = State.Locked;
    }

    /// Buyer's confirmation of delivery and release of funds. Seller receives price of goods and deposit. Buyer receives deposit.
    function confirmDelivery()
    function delivered()
        onlyBuyer
        inState(State.Locked)
    {
        GoodsReceived();
        state = State.Inactive;
        buyer.transfer(value);
        seller.transfer(this.balance);
    }

    /// Dispute resolution.
    function dispute()
        inState(State.Locked)
        condition(msg.value == (2))
        payable
    {
        Disputed();
        state = State.Locked;
    }
    
    function resolve()
        onlyArbitrator
        inState(State.Locked)
    {        
        Resolved();
        state = State.Inactive;
        buyer.transfer(value - 1);
        seller.transfer((value * 2) - 1);
        arbitrator.transfer(this.balance);
    }
    
    function terminate()
        onlyArbitrator
        inState(State.Locked)
    {          
        Terminated();
        state = State.Inactive;
        buyer.transfer((value * 2) - 1);
        seller.transfer((value * 2) - 1);
        arbitrator.transfer(this.balance);
    }
        
}
