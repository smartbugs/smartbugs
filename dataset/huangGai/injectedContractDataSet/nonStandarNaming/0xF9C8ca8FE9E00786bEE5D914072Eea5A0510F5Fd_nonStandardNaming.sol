                                                                 

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

interface ICurveGaugeMapping {

  struct GaugeData {
    address gaugeAddress;
    bool rewardToken;
  }

  function GAUGEMAPPING439(bytes32) external view returns(GaugeData memory);	//inject NONSTANDARD NAMING
}

interface TokenInterface {
    function BALANCEOF742(address) external view returns (uint);	//inject NONSTANDARD NAMING
}

interface IMintor {
    function MINTED437(address) external view returns (uint);	//inject NONSTANDARD NAMING
}

interface IGauge {
  function INTEGRATE_FRACTION856(address user) external view returns(uint256 amt);	//inject NONSTANDARD NAMING
  function LP_TOKEN427() external view returns(address token);	//inject NONSTANDARD NAMING
  function REWARDED_TOKEN28() external view returns(address token);	//inject NONSTANDARD NAMING
  function CRV_TOKEN827() external view returns(address token);	//inject NONSTANDARD NAMING
  function BALANCEOF742(address user) external view returns(uint256 amt);	//inject NONSTANDARD NAMING
  function REWARDS_FOR32(address user) external view returns(uint256 amt);	//inject NONSTANDARD NAMING
  function CLAIMED_REWARDS_FOR119(address user) external view returns(uint256 amt);	//inject NONSTANDARD NAMING
}

contract GaugeHelper {
  function GETCURVEGAUGEMAPPINGADDR166() internal pure returns (address){	//inject NONSTANDARD NAMING
    return 0x1C800eF1bBfE3b458969226A96c56B92a069Cc92;
  }

  function GETCURVEMINTORADDR2() internal pure returns (address){	//inject NONSTANDARD NAMING
    return 0xd061D61a4d941c39E5453435B6345Dc261C2fcE0;
  }

                                                
  function STRINGTOBYTES32152(string memory str) internal pure returns (bytes32 result) {	//inject NONSTANDARD NAMING
    require(bytes(str).length != 0, "string-empty");
    // solium-disable-next-line security/no-inline-assembly
    assembly {
      result := mload(add(str, 32))
    }
  }
}


contract Resolver is GaugeHelper {
    struct PositionData {
        uint stakedBal;
        uint crvEarned;
        uint crvClaimed;
        uint rewardsEarned;
        uint rewardsClaimed;
        uint crvBal;
        uint rewardBal;
        bool hasReward;
    }
    function GETPOSITION539(string memory gaugeName, address user) public view returns (PositionData memory positionData) { 	//inject NONSTANDARD NAMING
        ICurveGaugeMapping curveGaugeMapping = ICurveGaugeMapping(GETCURVEGAUGEMAPPINGADDR166());
        ICurveGaugeMapping.GaugeData memory curveGaugeData = curveGaugeMapping.GAUGEMAPPING439(
            bytes32(STRINGTOBYTES32152(gaugeName)
        ));
        IGauge gauge = IGauge(curveGaugeData.gaugeAddress);
        IMintor mintor = IMintor(GETCURVEMINTORADDR2());
        positionData.stakedBal = gauge.BALANCEOF742(user);
        positionData.crvEarned = gauge.INTEGRATE_FRACTION856(user);
        positionData.crvClaimed = mintor.MINTED437(user);

        if (curveGaugeData.rewardToken) {
            positionData.rewardsEarned = gauge.REWARDS_FOR32(user);
            positionData.rewardsClaimed = gauge.CLAIMED_REWARDS_FOR119(user);
            positionData.rewardBal = TokenInterface(address(gauge.REWARDED_TOKEN28())).BALANCEOF742(user);
        }

        positionData.crvBal = TokenInterface(address(gauge.CRV_TOKEN827())).BALANCEOF742(user);
    }

    function GETPOSITIONS560(string[] memory gaugesName, address user) public view returns (PositionData[] memory positions) {	//inject NONSTANDARD NAMING
        positions = new PositionData[](gaugesName.length);
        for (uint i = 0; i < gaugesName.length; i++) {
            positions[i] = GETPOSITION539(gaugesName[i], user);
        }
    }
}


contract InstaCurveGaugeResolver is Resolver {
    string public constant name548 = "Curve-Gauge-Resolver-v1";	//inject NONSTANDARD NAMING
}