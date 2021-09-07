// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract VolcanoCoin is ERC20("Volcano Coin", "VOC"), Ownable {
    uint256 currentPaymentIdentifier = 0;

    address immutable administrator;

    mapping(address => Payment[]) public payments;

    event TotalSupplyIncrease(uint256);

    enum PaymentType {
        unknown,
        basicPayment,
        refund,
        dividend,
        groupPayment
    }

    struct Payment {
        uint256 identifier;
        uint256 amount;
        address recipient;
        PaymentType paymentType;
        string comment;
        uint blockNumber;
    }

    struct Record {
        address sender;
        uint arrayIndex;
    }
    mapping(uint => Record) public paymentsFromId;

    constructor() {
        _mint(_msgSender(), 10000);
        administrator = _msgSender();
    }

    modifier onlyAdmin {
        require(_msgSender() == administrator);
        _;
    }

    function increaseTotalSupplyWith1000() public onlyOwner {
        _mint(_msgSender(), 1000);

        emit TotalSupplyIncrease(totalSupply());
    }

    function transfer(address _recipient, uint256 _amount)
        public
        virtual
        override
        returns (bool)
    {
        _transfer(_msgSender(), _recipient, _amount);

        payments[_msgSender()].push(
            Payment({
                identifier: currentPaymentIdentifier,
                amount: _amount,
                recipient: _recipient,
                paymentType: PaymentType.unknown,
                comment: "",
                blockNumber: block.number
            })
        );

        currentPaymentIdentifier++;

        return true;
    }

    function getPaymentDetails(address sender, uint id) public view returns(Payment memory, int256) {
        for (uint i = 0; i < payments[sender].length; i++) {
            if (payments[sender][i].identifier == id) {
                return (payments[sender][i], int(i));
            }
        }
        Payment memory emptyPayment;
        return (emptyPayment, -1);
    }

    function updatePaymentDetails(uint identifier, PaymentType paymentType, string memory comment) public {
        require(identifier > 0, "Invalid identifier");
        require(paymentType >= PaymentType.unknown && paymentType <= PaymentType.groupPayment, "Payment Type invalid");
        require(bytes(comment).length != 0, "Comment invalid");

        (, int256 i) = getPaymentDetails(_msgSender(), identifier);
        payments[_msgSender()][uint(i)].paymentType = paymentType;
        payments[_msgSender()][uint(i)].comment = comment;
    }

    function updatePaymentOnlyAdmin(uint id, PaymentType paymentType) public onlyAdmin {
        require(id != 0, "Id invalid");
        require(paymentType >= PaymentType.unknown && paymentType <= PaymentType.groupPayment, "Payment Type invalid");
        string memory text = string(abi.encodePacked("updated by ",Strings.toHexString(uint256(uint160(administrator)))));
        updatePaymentDetails(id, paymentType, text);
    }    
}
