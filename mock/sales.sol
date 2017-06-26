pragma solidity ^0.4.11;

contract SaleOfGoods {
    uint public value;
    address public seller;
    address public buyer;
    address public arbitrator;
    enum State { Created, Locked, Inactive, Disputed }
    State public state;

    function SaleOfGoods() payable {
        seller = msg.sender;
        value = msg.value / 2;
        arbitrator = 0x237f4d5F1BD369A167260A0D7fcECf83BB5f14eD;   //Hard-code the arbitrator's address
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

    event SellerRevokedOffer();
    event BuyerAcceptedOffer();
    event GoodsReceived();
    event DisputeResolutionProcessInitiated();
    event ArbitralAwardEnforced(uint sellerBalance, uint buyerBalance);
    event ContractRescinded(uint balanceToSend);

    /// Seller can revoke the offer and recover deposit before Buyer's acceptance.
    function sellerRevokeOffer()
        onlySeller
        inState(State.Created)
    {
        SellerRevokedOffer();
        state = State.Inactive;
        seller.transfer(this.balance);
    }

    /// Buyer submits deposit to accept Seller's offer, which lock funds until Seller's performance. Buyer's deposit is twice the value of the goods.
    function buyerAcceptOffer()
        inState(State.Created)
        condition(msg.value == (2 * value))
        payable
    {
        BuyerAcceptedOffer();
        buyer = msg.sender;
        state = State.Locked;
    }

    /// Buyer's confirmation of delivery and release of funds. Seller receives price of goods and deposit. Buyer receives deposit.
    function buyerConfirmDelivery()
        onlyBuyer
        inState(State.Locked)
    {
        GoodsReceived();
        state = State.Inactive;
        buyer.transfer(value);
        seller.transfer(this.balance);
    }

    /// Dispute resolution.
    function initiateDispute()
        inState(State.Locked)
        {
        DisputeResolutionProcessInitiated();
        state = State.Disputed;    //Set the state to Disputed
    }

    function arbitratorResolveDispute(uint deductFromSeller ,uint addToBuyer, uint deductFromBuyer)              // Pass each value for their respective operation, otherwise just pass 0
        onlyArbitrator
        inState(State.Disputed)                 // should be called in case when state is Disputed
    {
        uint sellerBalance = (((value*2)+value)/(1 ether) - deductFromSeller) * 1000000000000000000;   // 1000000000000000000 is for converting Wei to ether

       uint buyerBalance = (value/(1 ether) + addToBuyer - deductFromBuyer) * 1000000000000000000;// 1000000000000000000 is for converting Wei to ether

        ArbitralAwardEnforced(sellerBalance,buyerBalance);          // Fire resolved event

        state = State.Inactive;
        seller.transfer(sellerBalance);     //send balance to seller
        buyer.transfer(buyerBalance);   // send balance to buyer
        arbitrator.transfer(this.balance);
    }


    function arbitratorRescindContract(uint deductAmount)
        onlyArbitrator
        inState(State.Disputed)
    {

        // It will deduct the same amount from both Buyer and Seller
         uint balanceToSend = (value*2) - deductAmount * 1000000000000000000;// 1000000000000000000 is for converting Wei to ether

        ContractRescinded(balanceToSend);
        state = State.Inactive;
        buyer.transfer(balanceToSend);
        seller.transfer(balanceToSend);
        arbitrator.transfer(this.balance);
    }

    function arbitratorDeleteContract(){
         selfdestruct(arbitrator);
    }

}
