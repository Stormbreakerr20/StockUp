// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TokenizedStockBuying {
    
    struct Buyer {
        bytes32 buyerID;     
        uint256 price;          
        uint256 quantity;    
        string stock;           
        bool sold;               
        uint256 mobileNumber;   
    }

    uint256 public buyerCounter;
    mapping(bytes32 => Buyer) public buyers;   
    mapping(address => bytes32[]) public userStocks; 


    event StockBought(bytes32 buyerID, address buyerAddress, string stock, uint256 quantity, uint256 price);
    event StockSold(bytes32 buyerID, address buyerAddress, string stock, uint256 quantity);

    function buyStock(string memory _stock, uint256 _quantity, uint256 _price, uint256 _mobileNumber) public returns (bytes32) {
        buyerCounter++;
        bytes32 buyerID = keccak256(abi.encodePacked(block.timestamp, msg.sender, buyerCounter));
        
        buyers[buyerID] = Buyer(buyerID, _price, _quantity, _stock, false, _mobileNumber);
        
        userStocks[msg.sender].push(buyerID);

        emit StockBought(buyerID, msg.sender, _stock, _quantity, _price);

        return buyerID;
    }

    function sellStock(bytes32 _buyerID) public {
        require(buyers[_buyerID].buyerID == _buyerID, "Invalid buyer ID");
        require(!buyers[_buyerID].sold, "Stock already sold");

        buyers[_buyerID].sold = true;

        emit StockSold(_buyerID, msg.sender, buyers[_buyerID].stock, buyers[_buyerID].quantity);
    }

    function getStockDetails(bytes32 _buyerID) public view returns (Buyer memory) {
        return buyers[_buyerID];
    }

    function getUserStocks(address _user) public view returns (Buyer[] memory) {
        bytes32[] memory stockIds = userStocks[_user];
        Buyer[] memory userStockDetails = new Buyer[](stockIds.length);

        for (uint256 i = 0; i < stockIds.length; i++) {
            userStockDetails[i] = buyers[stockIds[i]];
        }

        return userStockDetails;
    }
}
