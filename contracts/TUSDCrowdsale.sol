// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "@openzeppelin/contracts/crowdsale/Crowdsale.sol";
import "@openzeppelin/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "@openzeppelin/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "@openzeppelin/contracts/crowdsale/distribution/FinalizableCrowdsale.sol";
import "@openzeppelin/contracts/crowdsale/distribution/PostDeliveryCrowdsale.sol";
import "@openzeppelin/contracts/crowdsale/distribution/RefundableCrowdsale.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract TusdCrowdsale is Crowdsale, CappedCrowdsale, TimedCrowdsale, FinalizableCrowdsale, PostDeliveryCrowdsale, RefundableCrowdsale {
    using SafeMath for uint256;

    IERC20 public stablecoin;
    uint256 private _minContribution;
    uint256 private _maxContribution;
    address private constant TUSD_ADDRESS = 0x40af3827F39D0EAcBF4A168f8D4ee67c121D11c9;

    constructor(
        uint256 rate,
        address payable wallet,
        IERC20 token,
        uint256 cap,
        uint256 openingTime,
        uint256 closingTime,
        uint256 goal,
        uint256 minContribution,
        uint256 maxContribution
    )
        CappedCrowdsale(cap)
        TimedCrowdsale(openingTime, closingTime)
        FinalizableCrowdsale()
        PostDeliveryCrowdsale()
        RefundableCrowdsale(goal, wallet)
        Crowdsale(rate, wallet, token, minContribution, maxContribution)
        public
    {
        stablecoin = IERC20(TUSD_ADDRESS);
        _minContribution = minContribution;
        _maxContribution = maxContribution;
    }

    function goalReached() public view returns (bool) {
        return weiRaised() >= goal();
    }

    function _calculateTokens(uint256 weiAmount) internal view returns (uint256) {
        return weiAmount.mul(rate());
    }


    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
        super._preValidatePurchase(beneficiary, weiAmount);
        require(weiAmount >= _minContribution, "Contribution is below the minimum limit");
        require(weiAmount <= _maxContribution, "Contribution exceeds the maximum limit");
    }

    function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
        require(stablecoin.transferFrom(beneficiary, wallet(), tokenAmount), "Transfer of TUSD failed");
        super._processPurchase(beneficiary, tokenAmount);
    }

    function _forwardFunds() internal {
        // Do nothing, funds are already transferred in _processPurchase
    }

    function _finalization() internal {
        if (goalReached()) {
            stablecoin.transfer(wallet(), stablecoin.balanceOf(address(this)));
        } else {
            stablecoin.transfer(msg.sender, stablecoin.balanceOf(address(this)));
        }
        super._finalization();
    }
}
