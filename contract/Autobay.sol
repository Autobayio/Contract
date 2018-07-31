



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

    ) internal {

        require(_fundAddress != address(0) && _hisAddress != address(0));



        fundAddress = _fundAddress;

        hisAddress = _hisAddress;



        uint256 amount = uint(17010000000).mul(uint(10) ** uint(decimals - 2));



        bool status = super.mint(_hisAddress, amount) == amount;



        if (status) {

            amount = uint(2457000000).mul(uint(10) ** uint(decimals - 1));

            status = super.mint(fundAddress, amount) == amount;

        }



        require(status == true);

    }



}
