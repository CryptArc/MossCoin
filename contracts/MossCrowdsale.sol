pragma solidity ^0.4.18;

import './crowdsale/Crowdsale.sol';
import './crowdsale/CappedCrowdsale.sol';

//pre ico crowdsale contract
contract MossCrowdsale is CappedCrowdsale {
    uint256[5][4] bonus;
    uint256[5] values; // bonus by send ether amount criteria
    uint256[4] ends; // bonus by ico timing criteria

    function MossCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _capEther, uint256 _minInvestFinney, uint256 _maxInvestFinney, address _wallet, address _token) public
        CappedCrowdsale(_capEther)
        Crowdsale(_startTime, _endTime, _rate, _minInvestFinney, _maxInvestFinney, _wallet, _token) 
    {
        values = [5 * 1 ether, 10 * 1 ether, 25 * 1 ether, 75 * 1 ether, _maxInvestFinney * 1 finney];
    }

    function getTokens(uint256 _wei) public view returns (uint256) {
        for (uint i = 0; i < values.length; ++i) {
            if (_wei >= values[i]) {
                continue;
            }

            for (uint j = 0; j < ends.length; ++i) {
                if (now >= ends[j]) {
                    continue;
                }

                return _wei * rate * bonus[j][i] / 100;
            }
        }

        assert(false);
    }
}

//main ico crowdsale contract
contract MossCrowdsalePre is MossCrowdsale {
    function MossCrowdsalePre(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _capEther, uint256 _minInvestFinney, uint256 _maxInvestFinney, address _wallet, address _token) public
        MossCrowdsale(_startTime, _endTime, _rate, _capEther, _minInvestFinney, _maxInvestFinney, _wallet, _token)
    {
        ends = [_endTime, _endTime, _endTime, _endTime];
        bonus[0] = [130, 135, 140, 145, 150];
    }
}

contract MossCrowdsaleMain is MossCrowdsale {
    function MossCrowdsaleMain(uint256 _startTime, uint256 _end1, uint256 _end2, uint256 _end3, uint256 _endTime, uint256 _rate, uint256 _capEther, uint256 _minInvestFinney, uint256 _maxInvestFinney, address _wallet, address _token) public
        MossCrowdsale(_startTime, _endTime, _rate, _capEther, _minInvestFinney, _maxInvestFinney, _wallet, _token)
    {
        ends = [_end1, _end2, _end3, _endTime];
        bonus[0] = [115, 120, 125, 130, 135];
        bonus[1] = [110, 116, 121, 126, 131];
        bonus[2] = [105, 111, 117, 122, 127];
        bonus[3] = [100, 106, 112, 118, 123];
    }
}