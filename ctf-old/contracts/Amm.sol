pragma solidity 0.8.11;
// SPDX-License-Identifier: MIT

/// @dev: Just using Token for simplicity
import {Token} from "./Token.sol";

contract Amm {
    /*
    ___ _        _                      _      _    _        
    / __| |_ __ _| |_ ___  __ ____ _ _ _(_)__ _| |__| |___ ___
    \__ \  _/ _` |  _/ -_) \ V / _` | '_| / _` | '_ \ / -_|_-<
    |___/\__\__,_|\__\___|  \_/\__,_|_| |_\__,_|_.__/_\___/__/
    */
    Token public immutable token0; // = _token0;
    Token public immutable token1; // = _token1;

    constructor(
        Token _token0,
        Token _token1
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
        uint256 amountFromUser,
        bool token1ForUser
    ) public {
        // Checks
        Token token_to_user   = token1ForUser ? token1 : token0;
        Token token_from_user = token1ForUser ? token0 : token1;
        uint amount_to_user   = getDeltaY(
            /*      x = */ token_from_user.balanceOf(address(this)),
            /*      y = */ token_to_user  .balanceOf(address(this)),
            /* deltaX = */ amountFromUser
        );
        // Interactions
        token_from_user.transferFrom(
            /*   from = */ msg.sender,
            /*     to = */ address(this),
            /* amount = */ amountFromUser
        );
        token_to_user.transfer(
            /*     to = */ address(token_to_user),
            /* amount = */ amount_to_user
        );
    }

    /// We have:
    /// Δy = (-yΔx)/(x+Δx)
    /// For full derivation, see ../docs/getDeltaY/result.svg.
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