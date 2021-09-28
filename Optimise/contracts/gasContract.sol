// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/access/Ownable.sol";

contract GasContract is Ownable {
    uint128 public totalSupply = 0;
    uint8 paymentCounter = 1;

    address[5] public administrators;
    enum PaymentType {
        Unknown,
        BasicPayment,
        Refund,
        Dividend,
        GroupPayment
    }

    mapping(address => uint128) public balances;
    mapping(address => Payment[]) payments;

    struct Payment {
        uint8 paymentID;
        PaymentType paymentType;
        address recipient;
        string recipientName; // max 12 characters
        uint128 amount;
    }

    modifier onlyAdmin() {
        require(checkForAdmin(msg.sender), "Gas Contract -  Caller not admin");
        _;
    }

    event SupplyChanged(address indexed, uint128 indexed);
    event Transfer(address indexed, uint128);
    event PaymentUpdated(
        address indexed admin,
        uint8 indexed ID,
        uint128 indexed amount,
        string recipient
    );

    constructor(address[] memory _admins) {
        totalSupply = 10000;
        balances[msg.sender] = totalSupply;
        setUpAdmins(_admins);
    }

    function welcome() public pure returns (string memory) {
        return "hello !";
    }

    function setUpAdmins(address[] memory _admins) public onlyOwner {
        address[5] memory temp_admins = administrators;
        for (uint8 ii = 0; ii < administrators.length; ii++) {
            if (_admins[ii] != address(0)) {
                temp_admins[ii] = _admins[ii];
            }
        }
        administrators = temp_admins;
    }

    function updateTotalSupply() public onlyOwner {
        totalSupply = totalSupply + 1000;
        balances[msg.sender] = totalSupply;
        emit SupplyChanged(msg.sender, totalSupply);
    }

    function checkForAdmin(address _user) public view returns (bool) {
        for (uint8 ii = 0; ii < administrators.length; ii++) {
            if (administrators[ii] == _user) {
                return true;
            }
        }
        return false;
    }

    function transfer(
        address _recipient,
        uint128 _amount,
        string memory _name
    ) public {
        require(
            balances[msg.sender] >= _amount,
            "Gas Contract - Sender has insufficient Balance"
        );
        require(
            bytes(_name).length < 13,
            "Gas Contract -  The recipient name is above max length of 12 characters"
        );
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        Payment memory payment;
        payment.paymentType = PaymentType.BasicPayment;
        payment.recipient = _recipient;
        payment.amount = _amount;
        payment.recipientName = _name;
        payment.paymentID = ++paymentCounter;
        payments[msg.sender].push(payment);
        emit Transfer(_recipient, _amount);
    }

    function updatePayment(
        address _user,
        uint8 _ID,
        uint128 _amount
    ) public onlyAdmin {
        require(
            _ID > 0,
            "Gas Contract - ID must be greater than 0"
        );
        require(
            _amount > 0,
            "Gas Contract - Amount must be greater than 0"
        );
        require(
            _user != address(0),
            "Gas Contract - Administrator must have a valid non zero address"
        );
        for (uint8 ii = 0; ii < payments[_user].length; ii++) {
            if (payments[_user][ii].paymentID == _ID) {
                payments[_user][ii].amount = _amount;
                emit PaymentUpdated(
                    msg.sender,
                    _ID,
                    _amount,
                    payments[_user][ii].recipientName
                );
                break;
            }
        }
    }

    function getPayments(address _user) public view returns (Payment[] memory) {
        require(
            _user != address(0),
            "Gas Contract - getPayments function - User must have a valid non zero address"
        );
        return payments[_user];
    }
}
