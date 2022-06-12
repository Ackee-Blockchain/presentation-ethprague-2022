pragma solidity 0.8.11;
// SPDX-License-Identifier: MIT

/// Implements [EIP20](https://eips.ethereum.org/EIPS/eip-20).
/// Not safe! Has bugs on purpose.
/// Does _not_ implement (decrease|increase)Allowance.
contract Token {
    /*
        ___ _        _                      _      _    _        
        / __| |_ __ _| |_ ___  __ ____ _ _ _(_)__ _| |__| |___ ___
        \__ \  _/ _` |  _/ -_) \ V / _` | '_| / _` | '_ \ / -_|_-<
        |___/\__\__,_|\__\___|  \_/\__,_|_| |_\__,_|_.__/_\___/__/
    */
    // region immutable
    string public constant name = "EthPrague";
    string public constant symbol = "ETHPRG";
    uint8 public constant decimals = 18;
    uint256 public constant PRICE = 1e20;
    uint256 public constant PRICE_MULTIPLIER = 1e18;
    address payable public immutable owner; // = msg.sender (deployer).
    // endregion immutable

    // region non-constant state variables
    uint256 public totalSupply; // = 0;
    mapping(address => uint256) public balances; // = collections.defaultdict(int);
    mapping(address => mapping(address => uint256)) public allowances; // = defaultdict(lambda: defaultdict(int));
    // endregion non-constant

    /*
        ___             _      
        | __|_ _____ _ _| |_ ___
        | _|\ V / -_) ' \  _(_-<
        |___|\_/\___|_||_\__/__/
    */
    event Approval(address indexed owner, address indexed spender, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Withdrawal(address indexed caller, address indexed recipient, uint256 value);

    /*
        ___      _    _ _    _                               _ _    _        __              _   _             
        | _ \_  _| |__| (_)__| |_  _ ___ __ _ __ __ ___ _____(_) |__| |___   / _|_  _ _ _  __| |_(_)___ _ _  ___
        |  _/ || | '_ \ | / _| | || |___/ _` / _/ _/ -_|_-<_-< | '_ \ / -_) |  _| || | ' \/ _|  _| / _ \ ' \(_-<
        |_|  \_,_|_.__/_|_\__|_|\_, |   \__,_\__\__\___/__/__/_|_.__/_\___| |_|  \_,_|_||_\__|\__|_\___/_||_/__/
                                |__/                                                                            
    */

    constructor() {
        owner = payable(msg.sender);
    }

    function balanceOf(address usr) public view returns (uint256) {
        return balances[usr];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowances[msg.sender][spender] = amount;
        emit Approval(
            /* owner = */ msg.sender,
            /* spender = */ spender,
            /* amount = */ amount
        );
        return true;
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        balances[msg.sender] -= amount;
        balances[to] += amount;

        _emit_transfer(
            /* from = */ msg.sender,
            /* to = */ to,
            /* amount = */ amount
        );

        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        // region correct
        // balances[from] -= amount;
        // balances[to] += amount;
        // endregion correct

        // region unsafe
        uint from_post_amount = balances[from] - amount;
        uint to_post_amount = balances[to] + amount;
        balances[from] = from_post_amount;
        balances[to] = to_post_amount;
        // endregion unsafe

        allowances[from][msg.sender] -= amount;

        _emit_transfer(
            /* from = */ from,
            /* to = */ to, 
            /* amount = */ amount
        );

        return true;
    }

    function mint() payable public returns (uint256 amount) {
        uint value = msg.value;
        amount = value * PRICE / PRICE_MULTIPLIER;
        // balances[msg.sender] += amount; /* <-- this is a bug! */
        totalSupply += amount;
        _emit_transfer(
            /* from = */ address(0),
            /* to = */ msg.sender,
            /* amount = */ amount
        );
    }

    /*
        _  _                       _    _ _    _                            _ _    _        __              _   _             
        | \| |___ _ _ ___ _ __ _  _| |__| (_)__| |_  _ ___ __ _ __ __ ___ __(_) |__| |___   / _|_  _ _ _  __| |_(_)___ _ _  ___
        | .` / _ \ ' \___| '_ \ || | '_ \ | / _| | || |___/ _` / _/ _/ -_|_-< | '_ \ / -_) |  _| || | ' \/ _|  _| / _ \ ' \(_-<
        |_|\_\___/_||_|  | .__/\_,_|_.__/_|_\__|_|\_, |   \__,_\__\__\___/__/_|_.__/_\___| |_|  \_,_|_||_\__|\__|_\___/_||_/__/
                        |_|                      |__/                                                                         
    */
    function withdraw() public {
        require(msg.sender == owner); 
        uint value = address(this).balance;
        // owner.transfer(
        //     /* value = */ value
        // ); /* <-- this is a bug! */
        emit Withdrawal(
            /* caller = */ msg.sender,
            /* recipient */ owner,
            /* value = */ value
        );
    }

    /*
        ___     _                     _    __              _   _             
        |_ _|_ _| |_ ___ _ _ _ _  __ _| |  / _|_  _ _ _  __| |_(_)___ _ _  ___
        | || ' \  _/ -_) '_| ' \/ _` | | |  _| || | ' \/ _|  _| / _ \ ' \(_-<
        |___|_||_\__\___|_| |_||_\__,_|_| |_|  \_,_|_||_\__|\__|_\___/_||_/__/
    */
    function _emit_transfer(
        address from,
        address to,
        uint256 amount
    ) internal {
        emit Transfer(
            /* from = */ from,
            /* to = */ to,
            /* amount = */ amount
        );
    }
}
