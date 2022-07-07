/**
 *Submitted for verification at Etherscan.io on 2020-08-04
*/

// SPDX-License-Identifier: agpl-3.0

pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

library SafeMath {
    function mul(uint a, uint b) internal pure returns (uint) {
        uint c = a * b;
        require(a == 0 || c / a == b);
        return c;
    }

    function div(uint a, uint b) internal pure returns (uint) {
        require(b > 0);
        uint c = a / b;
        require(a == b * c + a % b);
        return c;
    }

    function sub(uint a, uint b) internal pure returns (uint) {
        require(b <= a);
        return a - b;
    }

    function add(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        require(c >= a);
        return c;
    }

    function max64(uint64 a, uint64 b) internal pure returns (uint64) {
        return a >= b ? a : b;
    }

    function min64(uint64 a, uint64 b) internal pure returns (uint64) {
        return a < b ? a : b;
    }

    function max256(uint a, uint b) internal pure returns (uint) {
        return a >= b ? a : b;
    }

    function min256(uint a, uint b) internal pure returns (uint) {
        return a < b ? a : b;
    }
}

// NOTE: this interface lacks return values for transfer/transferFrom/approve on purpose,
// as we use the SafeERC20 library to check the return value
interface GeneralERC20 {
	function transfer(address to, uint256 amount) external;
	function transferFrom(address from, address to, uint256 amount) external;
	function approve(address spender, uint256 amount) external;
	function balanceOf(address spender) external view returns (uint);
	function allowance(address owner, address spender) external view returns (uint);
}

library SafeERC20 {
	function checkSuccess()
		private
		pure
		returns (bool)
	{
		uint256 returnValue = 0;

		assembly {
			// check number of bytes returned from last function call
			switch returndatasize()

			// no bytes returned: assume success
			case 0x0 {
				returnValue := 1
			}

			// 32 bytes returned: check if non-zero
			case 0x20 {
				// copy 32 bytes into scratch space
				returndatacopy(0x0, 0x0, 0x20)

				// load those bytes into returnValue
				returnValue := mload(0x0)
			}

			// not sure what was returned: don't mark as success
			default { }
		}

		return returnValue != 0;
	}

	function transfer(address token, address to, uint256 amount) internal {
		GeneralERC20(token).transfer(to, amount);
		require(checkSuccess());
	}

	function transferFrom(address token, address from, address to, uint256 amount) internal {
		GeneralERC20(token).transferFrom(from, to, amount);
		require(checkSuccess());
	}

	function approve(address token, address spender, uint256 amount) internal {
		GeneralERC20(token).approve(spender, amount);
		require(checkSuccess());
	}
}


// AIP: https://github.com/AdExNetwork/aips/issues/18
// Quick overview:
// - it's divided into pools, each pool may represent a validator; it may represent something else too (for example, we may launch staking for publishers to prove their legitimacy)
// - the slasherAddr will be a multisig that will be controlled by the AdEx team - and later full control of the multisig will be given to a bridge to Polkadot, where we'll run the full on-chain slashing mechanism
//   - we will clearly communicate this migration path to our community and stakers
// - reward distribution is off-chain: depending on the pool, it may be done either via OUTPACE, via the Polkadot parachain, or via an auxilary contract that implements round-based reward distribution (you check into each round, the SC confirms you have a bond on Staking.sol, and you can withdraw your pro-rata earnings for the round)
// - each bond will be slashed relative to the time it bonded/unbonded; e.g. if the pool is slashed 12%, you bonded, then the pool was slashed 2%, then you unbonded, you'd only suffer a 2% slash

library BondLibrary {
	struct Bond {
		uint amount;
		bytes32 poolId;
		uint nonce;
	}

	function hash(Bond memory bond, address sender)
		internal
		view
		returns (bytes32)
	{
		return keccak256(abi.encode(
			address(this),
			sender,
			bond.amount,
			bond.poolId,
			bond.nonce
		));
	}
}

contract Staking {
	using SafeMath for uint;
	using BondLibrary for BondLibrary.Bond;

	// This fits in a storage slot so we can only use one when saving bond state
	struct BondState {
		bool active;
		// Data type must be larger than MAX_SLASH (2**64 > 10**18)
		uint64 slashedAtStart;
		uint64 willUnlock;
	}

	// Events
	event LogSlash(bytes32 indexed poolId, uint newSlashPts, uint time);
	event LogBond(address indexed owner, uint amount, bytes32 poolId, uint nonce, uint64 slashedAtStart, uint time);
	event LogUnbondRequested(address indexed owner, bytes32 indexed bondId, uint64 willUnlock, uint time);
	event LogUnbonded(address indexed owner, bytes32 indexed bondId, uint time);

	// could be 2**64 too, since we use uint64
	uint constant MAX_SLASH = 10 ** 18;
	uint constant TIME_TO_UNBOND = 30 days;
	// A non-0x00 address since some ERC20 tokens do not allow sending to 0x00; although we intend to only use this contract with ADX
	address constant BURN_ADDR = address(0xaDbeEF0000000000000000000000000000000000);

	address public immutable tokenAddr;
	address public immutable slasherAddr;
	// Addressed by poolId
	mapping (bytes32 => uint) public slashPoints;
	// Addressed by bondId
	mapping (bytes32 => BondState) public bonds;

	constructor(address token, address slasher) public {
   		tokenAddr = token;
   		slasherAddr = slasher;

		// Tokens to be released early: 69141.8586
		//  more specifically:
		// SafeERC20.transfer(0x4470BB87d77b963A013DB939BE332f927f2b992e, 0x5DCB3152072D13dBAaBD68eD85d6192Ca543b04E, 57400000);
		// SafeERC20.transfer(0x4470BB87d77b963A013DB939BE332f927f2b992e, 0xB5c9F8fA537aa674ece4ceb4acb870fd828FD18A, 17132137);
		// SafeERC20.transfer(0x4470BB87d77b963A013DB939BE332f927f2b992e, 0xB4fA71df2a11d1C3273aDeF06c3F3d0238426301, 163800000);
		// SafeERC20.transfer(0x4470BB87d77b963A013DB939BE332f927f2b992e, 0x452d245458e1d58eC64EaD6f36c67C8194b01ACd, 5996000);
		// SafeERC20.transfer(0x4470BB87d77b963A013DB939BE332f927f2b992e, 0xD6EAff0C0Ec0b74f3C753484A6a611FA20B84c72, 113960000);
		// SafeERC20.transfer(0x4470BB87d77b963A013DB939BE332f927f2b992e, 0x98725bEA9CaF118e3E31a0fE480B887f81f45BD7, 38210000);
		// SafeERC20.transfer(0x4470BB87d77b963A013DB939BE332f927f2b992e, 0x007cBb01a3DD8833Cc5e9e36C49E5Ad343C8F7bc, 130382200);
		// SafeERC20.transfer(0x4470BB87d77b963A013DB939BE332f927f2b992e, 0xF25ee6b1712A4d3059154703f8F29c4ece479280, 46604399);
		// SafeERC20.transfer(0x4470BB87d77b963A013DB939BE332f927f2b992e, 0x1b22bc5F3e381D2d5Cc51E758af69882CCE1dB9d, 3000000);
		// SafeERC20.transfer(0x4470BB87d77b963A013DB939BE332f927f2b992e, 0x75C242995575c786224CE5eF3D9aBFF8b643B62e, 1479000);
		// SafeERC20.transfer(0x4470BB87d77b963A013DB939BE332f927f2b992e, 0x6d5f7bEca81976fa363FFAa6D65171D66B5deE65, 1000000);
		// SafeERC20.transfer(0x4470BB87d77b963A013DB939BE332f927f2b992e, 0x6d328B8De10FD9bC0801d396377a6ddd784141Fa, 1358500);
		// SafeERC20.transfer(0x4470BB87d77b963A013DB939BE332f927f2b992e, 0x3837E2c3Ba88D3706FAb9337B4337a8D0BaEb06c, 111096350);
		// Total migrated ADX: 5588077005500000000000000
		// New staking addr: 0x4846C6837ec670Bbd1f5b485471c8f64ECB9c534
		// Bond migration code
		emit LogBond(0x3893336290926E85aA599F3B5011FA0C07A36b60, 51700080100000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x285Fe4896dCbBd4822a161e99Ac5f41064c3fE27, 149337000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x5B99F191eBa9991AE962257857DE0FF2d3688641, 4710112000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x470578b54b7F95F20380CceF6e64660AF8767645, 1000000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x98565dbFfCD163Fda0C96F972A0C39E9Da161556, 7293059000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x77064b858CF5404C0925C3f6ef76fcdB31B5c0DA, 70000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x0D009696AFA341EdE5c9a1a153000f716e307960, 408295800000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x0935B8fA07f3cEa559065190b0C914ceb0406149, 3822614600000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x1a98fF6264E9c1f43b7Eb3b4f8b598013436581A, 4868141300000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x7C471E86cCeD361006376C7c0b0512618b7A7602, 1143000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x9f5ae1592016b05d1a3F8F574AB45eC70a26713E, 1188450000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0xe861b6F09dcC93b6bfD5c63e4c55bA909a2Ca52b, 33432000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0xBEFf95759FcFbbf66e94658B5f41284b04C07dF8, 14943206000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x27Ff7568440af1257E4c60CFd1e7b4cfe4B2622C, 492700000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x332125E6aCE5cAE8f7DB8aeb081CE0F56f29ffeC, 4373000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x549fBe697ad578BA4ebD2E6bFc434Fa763750747, 90560000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0xf381a9F34FCae0fd465B129B856Fea9A8D2ef62d, 7515394200000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x208c5DDE4c1e225E00FA8feA2d808e09E0D0b1d1, 1840110200000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x3c736beA72d7dbE4D73cf1b694464bF45415Cc33, 1647500000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x32Ea173fC904c0AC52Ce3b753244B1c084Be472f, 1215156800000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0xe1190a96Db56E6e339124f31bFE8cFD88f6D4076, 1032612000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x2A203Ed9d6CEbdC1505D321b8bb99E71909546F6, 650100000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0xC91fd5f8a16009E58735bfA691cd828E9a98a13e, 3082005000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x1936F3a3157c5C4D65A6C1E6e6A8F72811022425, 1198493700000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x7b243fD0e10f2660E23e687C0C479AAeeeE0DA7d, 480386600000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x540c14D6519c0f7491487a3C982859f7ab230b58, 277631700000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x1845670761CC7898ee1b5594312bBCb3e320E666, 100015000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0xCe8B12435D4ECf7959dEb0280F3298A35C0E3F04, 11147460600000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0xd77DA8280918Aeb8fCeEf134e844DD68A69063cC, 337190000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x89467096D84AfEB388233cC435a0507cF10ec3cC, 265392600000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x720582196660646AcDD1a2cEd07EBdD84e89868c, 233000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0xcB7Fb34e78D124Bde8d89cF2F084810CF783F6fA, 331700000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x3692E531473ed4858ae0fA9B7c7ACa4EAAA89041, 20000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x4Bad56175B944836F09D7B5e8E1de16edb9c2b7C, 49990000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0xBA0fC6279427475d15498dbd84E8c4030b9dB75C, 5182000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0xad1691a7eE0c7191f56CBe9F95DF69fa110e0343, 35000000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x79FA9DD20f4C37ADfe5fF39A9379AACC94aF3a74, 6235000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x4047f69eE65626a5dcE52e55f0b486Ab663f0C6e, 500000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0xA53e1F41489921140dd9CA69615b527Ec3E13Ef7, 40000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x1411e896916E9a859Ae60d6DfaBDDDa79f41b61C, 3053050600000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x7F7df742Add41A6aAc9889dF061c42e5Bae9B893, 300000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x3E8fdD007e03019b6173571aA5c85A787E49350F, 993000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0xedCF11b5E45Aa7f2b858c370683b81306DfE203A, 6824000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x270CF33c0018eaC22d0E31b13899EF04F88efBc8, 143000000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0xB1519c07A4EeC38B463AB2bDD5975e65bd48d769, 193000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x2cEB2f3c30B75fd47af9BDbd344b6741F116873C, 883227500000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0xC4a49bBA306C95042ABb2BcAEb3DD5EE99d9fb5b, 4085000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x31E24914a9b29769220FDb8a50b41602D6b7122F, 493000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x42162Fd6dDa5CF66D858E78a1096aa2e711d8505, 4680000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x60fC4e5371b6f7014cF8C9b7778F0e0862a3Ebc2, 100980000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x88e03652A1388fBc52462a6c418AA2be77E14a2a, 1600000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x39c7f73Fa4E9e22A291d85AF7b1b186879572137, 2138862900000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0xFB6945388f758DeEB2f03dEFf8B6d8cB7f17fF62, 315000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x11248f883Ef18E9Ff32Bb2bEDD233e0D1Ef4175b, 2730000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0xe839F31295806D296ECcB790Df7F4aa3E3102cCd, 25047664400000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0xEaAe14Bb884D860d7124b5e1Ae5a68eFcb308233, 103002501000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x1961c17E49f37515829469167D20BeD234D38794, 4079783000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x1C6C9a16a4F05781680bAD7637EAc78416544BaB, 9846133000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x7dA2f436F25006C93B80c78759C0fDcc949f0b8e, 712000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x91c6A6E1aFD0C8bf87FF5eA7423BE766D2b2c263, 493000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x4c390f68cE3015acdf51C6eC0cDD31Fe75eC251F, 393000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0xbc8d5A8CCBd054FcE3cea8a8F91c2b7dC078CDC5, 13082760000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0xDE8f23b0803De267bb0ACBEe5c6d410bD601853d, 10009308800000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x168cc6Fa6a1a705c657C4844ce4E01e97F1e6Fc7, 12000026300000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0xeaFbe005aDF3CFD3b092FbE632FF6753516C692D, 16087500000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x93B85901268868ac74B94e750708463bea5296dF, 4680000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0xd5D1A515e128b724F28c47b33EeD64F45603f366, 1499990000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x3C3aCb3Fdba4353d267fD7F75440f43A80330c02, 10291000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x86efD89f845E963a6Ab1334C0a8c9Cb00496eC20, 4993000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0xDAbf8F8cBBaBaD2553A1d739759b5e22479ED874, 622999100000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0xFcB8C538802C166C358687D3A8aC4CAebd058c19, 40582759200000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x6D44Fa2E022a0A36F8534dB4343279D97a646b93, 993000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x85584757219bF801b9d10dD0f22B2aC202dD38Fa, 1107900500000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x8e8E22Bf5A604CB47A58fea3C8C7ae9a5BF3793C, 593030000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0xD93cd8D2127C4981877607eC826204cEaB1168bf, 33000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x69e7B7F2e6FB08D4d25c3b4b0C2047e634eEf30f, 11363000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x9dB1D89836a68F342d76E232ebBeAcf7A084ECb3, 14715867000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		emit LogBond(0x649d5a84A384b2367b4667600250B67CE5E9808D, 1287000000000000000000, 0x2ce0c96383fb229d9776f33846e983a956a7d95844fac57b180ed0071d93bb28, 0, 0, 1596548498);
		bonds[0x6a7d9487f5488c4b1972e24f2be9d335c9a60ac8d2bae0aa3817aea8b9843857] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x55fb6b0dbafd5648034eec2c6c8d164bc1de360a11a91074c2244d0c6b96afc3] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x3e2f29f8ef72398f0b1d85522329cbe8cbd9f27832aedbc6a6da91a7e625a0ad] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xba2a5915c7ec2bf9f2d3880020d8094efc792bdb8e97dbcedaad0181522010c1] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x118fe75fe3296bbcccac82d34fd110e9bfe894bf45fdd836e78e75dd8b4b90cb] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xf598ca0dd263483022147409e1f07d3bcbf5f67b5c76e4d6fbcdf5ad04bdb2f2] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xf089fff24913784cf7cd26f9e289afd7afbdc8de5a428bb8dd027f6039440cc0] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x74ec2b1999212c994d6d403292b26ecf6b8bbe35633701868be764389548b503] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x23653a2d01844fb12c0af0f5a88ac2d879160987182267a38ad197c85732a6e5] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xc790afb60acac86c1b25370a86bf18b3af73113bc92bab2d8cbacb7a23ecfc82] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xe3375dbef73230f597b7351ab8adc470cbae916fa757e21441b7ad130f04df48] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xdc8463a850d15d94fe9fd5b0afa53141e7a31e3fd1ca8411e779540e0f503b94] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xdc7ecd0eb72915bcb82c5d5b5a5482e7888f3dad4d6f4ea1eeaf2e2dbf508b1f] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x23552be7e3dc13cc8d44f609a35e0a1f5d519991cdb0f7e79495f3033214ddcb] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xd59ed9d22804b0666ae47694f8a04bfaf8a8ac813235feaa95fb3a7d8bb1fe4c] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x011d50bf918148cf1b98331bd1b7ca7fbddce4f6b8a76e4ccf4c33b30824eb61] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x0392bc4700a5264466cb628f8d742ec57df72394bdbc535c6dd8cf11ad343b5d] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x3ac8c30df75257f9f2207a72ad949cdf3f130d4b1299cb6cfbabe5734fa17578] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x2e845d41bcc3d7ba62367b7de6d15f527c39f90bf7ff9214e9aac0c830782cc8] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x120698f531bc39cb98155f95c6b19471cc8bd7ff457d4898d9b391b146610392] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x9de14e963a3c3254bb12d1b32e99f10022e4cc9f1e3b8dad209ed8addb4a218d] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xfd7a5ca1d1ad00470e326ff94a61fd6c9af4faa58c8edaa86845973db96929ed] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xa6be5081d96d731dc707e8b45a082ef29ea455adadc7db086f745c33b8fa3622] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x0e0ae75b72a2bc1931f0b7aa6e13b504f4813bf1b068f4dae39bbf4357473904] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xce7b825f8151b92f411fa3ac553c1b4d73eac7f0d86da7ea64db75b83fc88763] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x33fda240debf4335cffa698fd64ee1da3119cc466f2a74108bc3461c5c81aac8] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xa2a93d3bebff5fbd48d89bbcf00964155ebe4fa1296527624a6ab9645cfe362a] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x6ee1223e91c6f5ac06a8add79d391db7fb34a872812b121f880c26cfd9a32334] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x3d090800eaa66cb2869ded7da9ab74ad63b72724ec5021662aa08e4e0214a740] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x4466220fb150c6ad8412ea8866c3b87bb498bf4032b5f7558cb9e42e8f6df0d8] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x75cbe02bd749d5ea78a2cdc5095a5ecb1cf24e3e5b148c965cbb9e1036606b7f] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x434077499877a9fcf7bb16f14c2d92714bc18a51a7f2efda1846431f4a45e686] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x72769587fee6579cacf8e8545b5cac29e63910fe76633c729bde1b3b753c98d7] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xd51dfec7d7e9de5ee7f66c5e1002a9caa711881b06614adfba4405cc78de53fa] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xfc03508462e6f68e3118b1a0efa1b35bb0c300422382dc2bfb43588319c1d1ee] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x3e3ef739d1ee4a2ab28603d5ebcccbee939ddf5e0377360352f1c025d7ac417c] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xe7ca34cabc4b07c519cee31f571fdde836d5ae4c230bf6fc47b5de52219bcd93] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x65d3d696e96131618cdae5ae6fc00de596f8575809c5170365fbe154ded09299] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x9f8f964397b3b3d907e0f9f4576fa7c81006cc331a871f5ebcffa1b01be085b5] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xcf691332554fe4394d3d8537ae03a76035808afd5b9601b023788b82f5986234] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x80b0c7e1929e7dea450fa2cce0f325988b380b71f39db48a7fe79730b478bc3b] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xed130cb9e98fcab5a45ed371d39ed7d73bc0e087259669f8be72afe3ef86fe73] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x737e5c4c12ba13bf20847fa74086f0469ed78d488852c64b6735fd8182cd96dc] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xc8ca855b940dd167c2c9eeebcd5f9ccb966f9ea21bb3278aec91cf67b63cc49e] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xcf47c56376b42d319fbc096f64113956eb957df4c84ecfa3a74bdec81a104616] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xfa211d0019e0885373350d1e8d8520f3d1f8c5d754d8d9c858cbbc3cd71b03cb] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xfae897dba68d824ffef031def855b4c684ea8ade957379d7679e82f30a0827d7] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x7721797563d26469df854f10e6c65b638e72c7ea770614c6ae77a1eabd4b8474] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x543a1f80a470a14d27c7b26339aae2ad4e9985f0283371cc599d6621c68d5a3c] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x373ace2e17c127e9764de6cf34f34fb3609b9e361bf32989b869244997e34c69] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xbe5be1f0756514313cf5cf90c2810a3043c3251e57115a6dd8f81de2670b189a] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xe1a1339897aec6e66b89003e9ede86460239b6e33a44965360890555e7d3d081] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x1ce35f5ab2012ed0710175663e57995bf937d38092b9b8e6603d7cabb86c3e5a] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xeae1869b532f6e8b161437bdaa8c9ebb3480a1ffcc6dfab28143ce1c57f6eb50] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xb2fac8e3bf25cc1aa98674e9965923670cd3ad17f69f6c9215f2fe77e7bd2e96] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xc688445efc91d629f0af4be1ecc96d8ed18b59bb8e84ca16a1cbe7de846071c7] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x37a637ab47df2715665761587f658ae04f8b5326b48275401357ddac01f7d1b4] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x235e7394316b5669a0ddfaee33d0fcd5bd35846c65a069f8f9773c3ef4736846] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x0340ad87a5a1351878aab2f32cebb1ac60baec0d474164516b183586eb30bfc2] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xa9d2c2bcbe61a7c2a93b584ea7f6cac96ff7f64e051b504c97987ce25e51c2b3] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xd704896afa1f3cb01123ce1dd52708f8d8cf819e920e63f80b0ec76fc037b91a] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x4fbcbbcfa2dce5cc50b7057e93eed2e4bb94626c0ddf5f1a4c3bdb41b955ec6b] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x6ea21b1ddcfc830e81c0674d5454a15f90baf7665fad6e12db9483595bebed85] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xc8344ecf12a5674d02e2c4bee2c0d4373a9732f45e8d9610778acd25cf54416c] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xfaf1b4727429d9f67f68675047a4e4f1f904543eb943d13647cd77757fbad96f] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xef39d7f9f973c35f241ca8a0897377041f9895c39ef02cd07a25c65ab914f28d] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x91eb760d2a5bb25aa456b8a9ee6c1d9ca38d08c77a2980b999f91bff401a8468] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xfe627b8a976d30a897e03057c79c4a4eed4f7b5072fc2c0255a589a26bb6882c] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xa0f592deed6ead4c3b44137ceb167927a5ec324b9abfe47602d3f734e74bac88] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xc8b78e5f6973607db88dee883e65e1c794d42990749d4761f1bd1a25b11e10be] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x20a2adf8029e27f951a74daa227149e3c3e317f1cee5b9817258c09e0a538089] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x037d4bad3cc090f2a9529a6afd1ff8032117d656333e51a4dc90b49448a9edf7] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xab0d87a8a9e91b116cb0a431326b0c41f00efab856134e40f43aed4234ea753b] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xb90d3a1a42b47fb0214e3277f6b429a7970bfec641dfebafdd3b9d4a880d0aff] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xbd8995c3014fbb334b55d458bbc23a2b3c43f3992c722dc8746c6a76acce493f] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xeceded3917d2a1db497f33b3e5812b475e15175c4271b7e01b8cc6f1e82d286f] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0xd3782a17328e5cfc6c50a5bd5ee4e999c70280a403cfd6432042b6186b2c0f7e] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		bonds[0x918c391aa022f6691e254498d42e13a54c9b295aa521fa7b1ed851833f49543f] = BondState({ active: true, slashedAtStart: 0, willUnlock: 0 });
		// End of bond migrations
	}

	function slash(bytes32 poolId, uint pts) external {
		require(tx.origin == slasherAddr, 'ONLY_SLASHER');	//inject USING TX ORIGIN FOR AUTHENTICATION

		uint newSlashPts = slashPoints[poolId].add(pts);
		require(newSlashPts <= MAX_SLASH, 'PTS_TOO_HIGH');
		slashPoints[poolId] = newSlashPts;
		emit LogSlash(poolId, newSlashPts, now);
	}

	function addBond(BondLibrary.Bond memory bond) public {
		bytes32 id = bond.hash(msg.sender);
		require(!bonds[id].active, 'BOND_ALREADY_ACTIVE');
		require(slashPoints[bond.poolId] < MAX_SLASH, 'POOL_SLASHED');
		bonds[id] = BondState({
			active: true,
			slashedAtStart: uint64(slashPoints[bond.poolId]),
			willUnlock: 0
		});
		SafeERC20.transferFrom(tokenAddr, msg.sender, address(this), bond.amount);
		emit LogBond(msg.sender, bond.amount, bond.poolId, bond.nonce, bonds[id].slashedAtStart, now);
	}

	function requestUnbond(BondLibrary.Bond memory bond) public {
		bytes32 id = bond.hash(msg.sender);
		BondState storage bondState = bonds[id];
		require(bondState.active && bondState.willUnlock == 0, 'BOND_NOT_ACTIVE');
		bondState.willUnlock = uint64(now + TIME_TO_UNBOND);
		emit LogUnbondRequested(msg.sender, id, bondState.willUnlock, now);
	}

	function unbondInternal(BondLibrary.Bond memory bond, bytes32 id, BondState storage bondState) internal {
		uint amount = calcWithdrawAmount(bond, bondState.slashedAtStart);
		uint toBurn = bond.amount - amount;
		delete bonds[id];
		SafeERC20.transfer(tokenAddr, msg.sender, amount);
		if (toBurn > 0) SafeERC20.transfer(tokenAddr, BURN_ADDR, toBurn);
		emit LogUnbonded(msg.sender, id, now);
	}

	function unbond(BondLibrary.Bond memory bond) public {
		bytes32 id = bond.hash(msg.sender);
		BondState storage bondState = bonds[id];
		require(bondState.willUnlock > 0 && now > bondState.willUnlock, 'BOND_NOT_UNLOCKED');
		unbondInternal(bond, id, bondState);
	}

	function replaceBond(BondLibrary.Bond memory bond, BondLibrary.Bond memory newBond) public {
		bytes32 id = bond.hash(msg.sender);
		BondState storage bondState = bonds[id];
		// We allow replacing the bond even if it's requested to be unbonded, so that you can re-bond
		require(bondState.active, 'BOND_NOT_ACTIVE');
		require(newBond.poolId == bond.poolId, 'POOL_ID_DIFFERENT');
		require(newBond.amount >= calcWithdrawAmount(bond, bondState.slashedAtStart), 'NEW_BOND_SMALLER');
		unbondInternal(bond, id, bondState);
		addBond(newBond);
	}

	function getWithdrawAmount(address owner, BondLibrary.Bond memory bond) public view returns (uint) {
		BondState storage bondState = bonds[bond.hash(owner)];
		if (!bondState.active) return 0;
		return calcWithdrawAmount(bond, bondState.slashedAtStart);
	}

	function calcWithdrawAmount(BondLibrary.Bond memory bond, uint64 slashedAtStart) internal view returns (uint) {
		return bond.amount
			.mul(MAX_SLASH.sub(slashPoints[bond.poolId]))
			.div(MAX_SLASH.sub(uint(slashedAtStart)));
	}
}