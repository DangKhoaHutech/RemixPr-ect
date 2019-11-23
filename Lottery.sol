pragma solidity ^0.5.12; // xác định phiên bản solidity đang dùng

contract Lottery { // khai báo khởi tạo hợp đồng
    address payable[] public players;// khai báo một mảng động địa chỉ players
    address public manage; // khai báo địa chỉ chủ sở hữu
    address public Player_win;
    
    constructor() public{
        manage= msg.sender; // xác định manage là chủ của hợp đồng
    }
    modifier Manage{ // xác định điều kiện chung
        require(msg.sender==manage);// địa chỉ phải là địa chỉ của chủ sở hữu hợp đồng
        _;
    }

    function receive_money () public payable{
        require (msg.value >= 1 ether);
        
    }
    
        function view_Money() public view Manage returns(uint){ // hàm xem số dư hiện tại của hợp đồng
        return address(this).balance; // trả về số dư
    }
    
    function Random_Hash() view public Manage returns(uint256){ // hàm ramdom mã băm SHA3
        return uint256(keccak256(abi.encodePacked(block.difficulty,block.timestamp,players.length)));
        // trả về chuỗi băm kiểu uint 256 bit 
        // hàm keccak256() là hàm băm, dùng SHA-3.
        // block.difficulty mức độ phức tạp của hàm băm
        // block.timestamp lấy móc thời gian hiện tại 
        // lấy chiều dài của mảng players
    }
    function Players_Win () public Manage{ // hàm random players chiến thắng
        
        uint Index= Random_Hash() % players.length; // lấy phần dư của chuỗi băm với độ dài người chơi trong mảng.
        Player_win = players[Index]; // trỏ đến địa chỉ người chơi thông qua index.
        players[Index].transfer(address(this).balance);// chuyển tiền đến địa chỉ người thắng cuộc
        players.length=0;
    }
}
