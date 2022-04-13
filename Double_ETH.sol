// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.6.0 <0.9.0;

contract DoubleIt {
    address payable owner;

    constructor() payable {
        owner = payable(msg.sender);
        payable(address(this)).transfer(msg.value);
    }

    function enter() public payable {
        //make sure we have double the amount in the contract
        require(
            msg.value < maxBet(),
            "the contract doesn't have enough money to double yours."
        );
        //send 10 persent to owner
        uint256 ownerCut = (msg.value * 1000) / 10000;
        uint256 remainder = msg.value - ownerCut;
        owner.transfer(ownerCut);

        //send double the remainder to the play.
        uint256 rand = getRandomNumber(3); //33% chance (0,1,2)
        if (rand == 0) {
            //wins
            payable(msg.sender).transfer(remainder * 2);
        }
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only the owner can call this.");
        _;
    }

    function balance() public view returns (uint256) {
        return address(this).balance;
    }

    function withdraw() public payable onlyOwner {
        owner.transfer(address(this).balance);
    }

    function maxBet() public view returns (uint256) {
        return address(this).balance / 2;
    }

    function chargeContract() public payable {
        //charges the contract.
    }

    function getRandomNumber(uint256 resultCount)
        private
        view
        onlyOwner
        returns (uint256)
    {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        msg.sender,
                        block.difficulty,
                        block.timestamp,
                        resultCount
                    )
                )
            ) % resultCount;
    }
}
