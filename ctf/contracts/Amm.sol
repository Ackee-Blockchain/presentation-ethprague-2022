pragma solidity 0.8.11;

/// @dev: Just using TokenAndIco for simplicity
import {TokenAndIco} from "./TokenAndIco.sol";

contract Amm {
    /*
    ___ _        _                      _      _    _        
    / __| |_ __ _| |_ ___  __ ____ _ _ _(_)__ _| |__| |___ ___
    \__ \  _/ _` |  _/ -_) \ V / _` | '_| / _` | '_ \ / -_|_-<
    |___/\__\__,_|\__\___|  \_/\__,_|_| |_\__,_|_.__/_\___/__/
    */
    TokenAndIco public immutable token0; // = _token0;
    TokenAndIco public immutable token1; // = _token1;

    constructor(
        TokenAndIco _token0,
        TokenAndIco _token1
    ) {
        token0 = _token0;
        token1 = _token1;
    }

    /*
    ___      _    _ _       __              _   _             
    | _ \_  _| |__| (_)__   / _|_  _ _ _  __| |_(_)___ _ _  ___
    |  _/ || | '_ \ | / _| |  _| || | ' \/ _|  _| / _ \ ' \(_-<
    |_|  \_,_|_.__/_|_\__| |_|  \_,_|_||_\__|\__|_\___/_||_/__/
    */
    function swap(
        uint256 amountToUser,
        bool token1ForUser
    ) public {
        token_to_user = token1ForUser ? token1 : token0;
        token_from_user = token1ForUser ? token0 : token1;
        uint amount_from_user = getDeltaY(
            /*x*/=token_to_user.balanceOf(address(this)),
            /*y=*/token_from_user.balanceOf(address(this)),
            /*deltaX=*/amountToUser
        );
        token_from_user.transferFrom(
            /*from=*/msg.sender,
            /*to=*/address(this),
            /*amount=*/amount_from_user
        )
        token_to_user.transfer(
            /*to=*/msg.sender,
            /*amount=*/amountToUser
        )
    }

    /*
    ___     _                     _    __              _   _             
    |_ _|_ _| |_ ___ _ _ _ _  __ _| |  / _|_  _ _ _  __| |_(_)___ _ _  ___
    | || ' \  _/ -_) '_| ' \/ _` | | |  _| || | ' \/ _|  _| / _ \ ' \(_-<
    |___|_||_\__\___|_| |_||_\__,_|_| |_|  \_,_|_||_\__|\__|_\___/_||_/__/
    */
    /// We have:
    /// Δy = (-yΔx)/(x+Δx)
    /// For full derivation, see /docs/get_delta/result.svg.
    function getDeltaY(
        uint x,
        uint y,
        uint deltaX
    ) public pure returns (uint256 deltaY) {
        uint num = y * deltaX;
        uint den = x + deltaX;
        deltaY = num / den;
    }
}