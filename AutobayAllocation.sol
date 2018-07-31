pragma solidity 0.4.19;



import "./Ownable.sol";

import "./Autobay.sol";

import "./SafeMath.sol";

import "./ICO.sol";





contract AutobayAllocation is Ownable {



    using SafeMath for uint256;



    uint256 public constant DECIMALS = 18;



    uint256 public constant MONTH_SECONDS = 2629744;



    Allocation[] public allocations;



    Autobay public autobay;



    ICO public ico;



    struct Allocation {

        address holderAddress;

        uint256 amount;

        bool sent;

    }



    function AutobayAllocation(

        address _autobay,

        address _ico

    ) public {

        require(_autobay != address(0) && _ico != address(0));

        autobay = Autobay(_autobay);

        ico = ICO(_ico);

    }



    function setAutobay(address _autobay) public onlyOwner {

        require(_autobay != address(0));

        autobay = Autobay(_autobay);

    }



    function setICO(address _ico) public onlyOwner {

        require(_ico != address(0));

        ico = ICO(_ico);

    }



    function claim() public {

        allocateInternal(msg.sender, now);

    }



    function allocate() public onlyOwner {

        allocateInternal(address(0), now);

    }



    function setAllocation() public onlyOwner {

        allocations.push(Allocation(

        0x61612C3Dd28624265929a8deF4CbA580680FCa3E,

        uint(94500000000).mul(uint(10) ** uint(DECIMALS - 2)),

        false

        ));

    
    }



    function allocateInternal(address _holder, uint256 _currentTime) internal {



        for (uint256 i = 0; i < allocations.length; i++) {

            if (_holder != address(0) && allocations[i].holderAddress != _holder) {

                continue;

            }

            if (true == allocations[i].sent) {

                continue;

            }

            Allocation storage allocation = allocations[i];

            allocation.sent = true;



            require(allocation.amount == autobay.mint(allocation.holderAddress, allocation.amount));

        }


    }



}