pragma solidity 0.4.19;





import "./MintingERC20.sol";

import "./ICO.sol";

import "./SafeMath.sol";





contract Autobay is MintingERC20 {



    using SafeMath for uint256;



    ICO public ico;



    address public fundAddress;

    address public bountyAddress;

    address public hisAddress;

    address public allowedAddress;



    bool public transferFrozen = true;



    function Autobay(

        address _fundAddress,

        address _bountyAddress,

        address _hisAddress,

        bool _locked

    )

        public MintingERC20(0, maxSupply, "Autobay", 18, "ABX", false, _locked)

    {

        standard = "ABX 0.1";



        maxSupply = uint(945000000).mul(uint(10) ** decimals);



        initialAllocation(_fundAddress, _hisAddress, _bountyAddress);

    }



    function setICO(address _ico) public onlyOwner {

        require(_ico != address(0));

        ico = ICO(_ico);

    }



    function setAllowedAddress(address _allowedAddress) public onlyOwner {

        require(_allowedAddress != address(0));

        allowedAddress = _allowedAddress;

    }



    function setLocked(bool _locked) public onlyOwner {

        locked = _locked;

    }



    function freezing(bool _transferFrozen) public onlyOwner {

        if (address(ico) != address(0) && ico.isICOFinished()) {

            transferFrozen = _transferFrozen;

        }

    }



    function mint(address _addr, uint256 _amount) public onlyMinters returns (uint256) {

        if (msg.sender == owner) {

            require(address(ico) != address(0));

            if (ico.isICOFinished() || _addr == allowedAddress) {

                return super.mint(_addr, _amount);

            }

            return uint256(0);

        }

        return super.mint(_addr, _amount);

    }


      function transferAllowed(address _address) public view returns (bool) {

        if (_address == bountyAddress) {

            return true;
        }

        return !transferFrozen;
    }


    function transfer(address _to, uint _value) public returns (bool) {

        require(transferAllowed(msg.sender));

        return super.transfer(_to, _value);

    }



    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {

        require(transferAllowed(_from));

        return super.transferFrom(_from, _to, _value);

    }



    function initialAllocation(

        address _fundAddress,

        address _hisAddress,

        address _bountyAddress

    ) internal {

        require(_fundAddress != address(0) && _hisAddress != address(0) && _bountyAddress != address(0));



        fundAddress = _fundAddress;

        hisAddress = _hisAddress;

        bountyAddress = _bountyAddress;



        uint256 amount = uint(17010000000).mul(uint(10) ** uint(decimals - 2));



        bool status = super.mint(_hisAddress, amount) == amount;


	  if (status) {

            amount = uint(10000000).mul(uint(10) ** decimals);

            status = super.mint(bountyAddress, amount) == amount;
        }


        if (status) {

            amount = uint(2457000000).mul(uint(10) ** uint(decimals - 1));

            status = super.mint(fundAddress, amount) == amount;

        }



        require(status == true);

    }



}