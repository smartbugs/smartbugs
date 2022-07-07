/**
 *Submitted for verification at Etherscan.io on 2020-03-26
*/

pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;


interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


library AbstractERC20 {

    function abstractReceive(IERC20 token, uint256 amount) internal returns(uint256) {
        if (token == IERC20(0)) {
            require(msg.value == amount);
            return amount;
        } else {
            uint256 balance = abstractBalanceOf(token, address(this));
            token.transferFrom(msg.sender, address(this), amount);
            uint256 cmp_amount = abstractBalanceOf(token, address(this)) - balance;
            require(cmp_amount != 0);
            return cmp_amount;
        }
    }

    function abstractTransfer(IERC20 token, address to, uint256 amount) internal returns(uint256) {
        if (token == IERC20(0)) {
            payable(to).transfer(0);
            return amount;
        } else {
            uint256 balance = abstractBalanceOf(token, address(this));
            token.transfer(to, amount);
            uint256 cmp_amount = balance - abstractBalanceOf(token, address(this));
            require(cmp_amount != 0);
            return cmp_amount;
        }
    }

    function abstractBalanceOf(IERC20 token, address who) internal view returns (uint256) {
        if (token == IERC20(0)) {
            return who.balance;
        } else {
            return token.balanceOf(who);
        }
    }
}


library Groth16Verifier {
  uint constant q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
  uint constant r = 21888242871839275222246405745257275088548364400416034343698204186575808495617;

  struct G1Point {
    uint X;
    uint Y;
  }
  // Encoding of field elements is: X[0] * z + X[1]
  struct G2Point {
    uint[2] X;
    uint[2] Y;
  }

  /// @return the sum of two points of G1
  function addition(G1Point memory p1, G1Point memory p2) internal view returns (G1Point memory) {
    G1Point memory t;
    uint[4] memory input;
    input[0] = p1.X;
    input[1] = p1.Y;
    input[2] = p2.X;
    input[3] = p2.Y;
    bool success;
    /* solium-disable-next-line */
    assembly {
      success := staticcall(sub(gas(), 2000), 6, input, 0xc0, t, 0x60)
      // Use "invalid" to make gas estimation work
      switch success case 0 { invalid() }
    }
    require(success);
    return t;
  }

  /// @return the product of a point on G1 and a scalar, i.e.
  /// p == p.scalar_mul(1) and p.addition(p) == p.scalar_mul(2) for all points p.
  function scalar_mul(G1Point memory p, uint s) internal view returns (G1Point memory) {
    if(s==0) return G1Point(0,0);
    if(s==1) return p;
    G1Point memory t;
    uint[3] memory input;
    input[0] = p.X;
    input[1] = p.Y;
    input[2] = s;
    bool success;
    /* solium-disable-next-line */
    assembly {
      success := staticcall(sub(gas(), 2000), 7, input, 0x80, t, 0x60)
      // Use "invalid" to make gas estimation work
      switch success case 0 { invalid() }
    }
    require (success);
    return t;
  }


  function verify(uint[] memory input, uint[8] memory proof, uint[] memory vk) internal view returns (bool) {
    uint nsignals = (vk.length-16)/2;
    require((nsignals>0) && (input.length == nsignals) && (proof.length == 8) && (vk.length == 16 + 2*nsignals));

    for(uint i=0; i<input.length; i++)
      require(input[i]<r);


    uint[] memory p_input = new uint[](24);

    p_input[0] = proof[0];
    p_input[1] = q-(proof[1]%q);  //proof.A negation
    p_input[2] = proof[2];
    p_input[3] = proof[3];
    p_input[4] = proof[4];
    p_input[5] = proof[5];

    // alpha1 computation
    p_input[6] = vk[0];     //vk.alfa1 == G1Point(vk[0], vk[1])
    p_input[7] = vk[1];


    p_input[8] = vk[2];
    p_input[9] = vk[3];
    p_input[10] = vk[4];
    p_input[11] = vk[5];

    //vk_x computation
    G1Point memory t = G1Point(vk[14], vk[15]);  //vk.IC[0] == G1Point(vk[14], vk[15])
    for(uint j = 0; j < nsignals; j++)
      t = addition(t, scalar_mul(G1Point(vk[16+2*j], vk[17+2*j]), input[j]));  //vk.IC[j + 1] == G1Point(vk[16+2*j], vk[17+2*j])

    p_input[12] = t.X;
    p_input[13] = t.Y;

    p_input[14] = vk[6];
    p_input[15] = vk[7];
    p_input[16] = vk[8];
    p_input[17] = vk[9];

    //C computation
    p_input[18] = proof[6];   //proof.C == G1Point(proof[6], proof[7])
    p_input[19] = proof[7];

    p_input[20] = vk[10];
    p_input[21] = vk[11];
    p_input[22] = vk[12];
    p_input[23] = vk[13];


    uint[1] memory out;
    bool success;
    // solium-disable-next-line 
    assembly {
      success := staticcall(sub(gas(), 2000), 8, add(p_input, 0x20), 768, out, 0x20)
      // Use "invalid" to make gas estimation work
      switch success case 0 { invalid() }
    }

    require(success);
    return out[0] != 0;
  }

}



library MerkleProof {
    function keccak256MerkleProof(
        bytes32[8] memory proof,
        uint256 path,
        bytes32 leaf
    ) internal pure returns (bytes32) {
        bytes32 root = leaf;
        for (uint256 i = 0; i < 8; i++) {
            root = (path >> i) & 1 == 0
                ? keccak256(abi.encode(leaf, proof[i]))
                : keccak256(abi.encode(proof[i], leaf));
        }
        return root;
    }

    //compute merkle tree for up to 256 leaves
    function keccak256MerkleTree(bytes32[] memory buff)
        internal
        pure
        returns (bytes32)
    {
        uint256 buffsz = buff.length;
        bytes32 last_tx = buff[buffsz - 1];
        for (uint8 level = 1; level < 8; level++) {
            bool buffparity = (buffsz & 1 == 0);
            buffsz = (buffsz >> 1) + (buffsz & 1);

            for (uint256 i = 0; i < buffsz - 1; i++) {
                buff[i] = keccak256(abi.encode(buff[2 * i], buff[2 * i + 1]));
            }
            buff[buffsz - 1] = buffparity
                ? keccak256(
                    abi.encode(buff[2 * buffsz - 2], buff[2 * buffsz - 1])
                )
                : keccak256(abi.encode(buff[2 * buffsz - 2], last_tx));
            last_tx = keccak256(abi.encode(last_tx, last_tx));
        }
        return buff[0];
    }
}



contract UnstructuredStorage {
    function set_uint256(bytes32 pos, uint256 value) internal {
        // solium-disable-next-line
        assembly {
            sstore(pos, value)
        }
    }

    function get_uint256(bytes32 pos) internal view returns(uint256 value) {
        // solium-disable-next-line
        assembly {
            value:=sload(pos)
        }
    }

    function set_address(bytes32 pos, address value) internal {
        // solium-disable-next-line
        assembly {
            sstore(pos, value)
        }
    }

    function get_address(bytes32 pos) internal view returns(address value) {
        // solium-disable-next-line
        assembly {
            value:=sload(pos)
        }
    }


    function set_bool(bytes32 pos, bool value) internal {
        // solium-disable-next-line
        assembly {
            sstore(pos, value)
        }
    }

    function get_bool(bytes32 pos) internal view returns(bool value) {
        // solium-disable-next-line
        assembly {
            value:=sload(pos)
        }
    }

    function set_bytes32(bytes32 pos, bytes32 value) internal {
        // solium-disable-next-line
        assembly {
            sstore(pos, value)
        }
    }

    function get_bytes32(bytes32 pos) internal view returns(bytes32 value) {
        // solium-disable-next-line
        assembly {
            value:=sload(pos)
        }
    }


    function set_uint256(bytes32 pos, uint256 offset, uint256 value) internal {
        // solium-disable-next-line
        assembly {
            sstore(add(pos, offset), value)
        }
    }

    function get_uint256(bytes32 pos, uint256 offset) internal view returns(uint256 value) {
        // solium-disable-next-line
        assembly {
            value:=sload(add(pos, offset))
        }
    }

    function set_uint256_list(bytes32 pos, uint256[] memory list) internal {
        uint256 sz = list.length;
        set_uint256(pos, sz);
        for(uint256 i = 0; i<sz; i++) {
            set_uint256(pos, i+1, list[i]);
        }
    }

    function get_uint256_list(bytes32 pos) internal view returns (uint256[] memory list) {
        uint256 sz = get_uint256(pos);
        list = new uint256[](sz);
        for(uint256 i = 0; i < sz; i++) {
            list[i] = get_uint256(pos, i+1);
        }
    }
}



contract OptimisticRollup is UnstructuredStorage {
    struct Message {
        uint256[4] data;
    }

    struct TxExternalFields {
        address owner;
        Message[2] message;
    }

    struct Proof {
        uint256[8] data;
    }

    struct VK {
        uint256[] data;
    }

    struct Tx {
        uint256 rootptr;
        uint256[2] nullifier;
        uint256[2] utxo;
        IERC20 token;
        uint256 delta;
        TxExternalFields ext;
        Proof proof;
    }

    struct BlockItem {
        Tx ctx;
        uint256 new_root;
        uint256 deposit_blocknumber;
    }
    struct BlockItemNote {
        bytes32[8] proof;
        uint256 id;
        BlockItem item;
    }

    struct UTXO {
        address owner;
        IERC20 token;
        uint256 amount;
    }

    struct PayNote {
        UTXO utxo;
        uint256 blocknumber;
        uint256 txhash;
    }

    bytes32 constant PTR_ROLLUP_BLOCK = 0xd790c52c075936677813beed5aa36e1fce5549c1b511bc0277a6ae4213ee93d8; // zeropool.instance.rollup_block
    bytes32 constant PTR_DEPOSIT_STATE = 0xc9bc9b91da46ecf8158f48c23ddba2c34e9b3dffbc3fcfd2362158d58383f80b; //zeropool.instance.deposit_state
    bytes32 constant PTR_WITHDRAW_STATE = 0x7ad39ce31882298a63a0da3c9e2d38db2b34986c4be4550da17577edc0078639; //zeropool.instance.withdraw_state

    bytes32 constant PTR_ROLLUP_TX_NUM = 0xeeb5c14c43ac322ae6567adef70b1c44e69fe064f5d4a67d8c5f0323c138f65e; //zeropool.instance.rollup_tx_num
    bytes32 constant PTR_ALIVE = 0x58feb0c2bb14ff08ed56817b2d673cf3457ba1799ad05b4e8739e57359eaecc8; //zeropool.instance.alive
    bytes32 constant PTR_TX_VK = 0x08cff3e7425cd7b0e33f669dbfb21a086687d7980e87676bf3641c97139fcfd3; //zeropool.instance.tx_vk
    bytes32 constant PTR_TREE_UPDATE_VK = 0xf0f9fc4bf95155a0eed7d21afd3dfd94fade350663e7e1beccf42b5109244d86; //zeropool.instance.tree_update_vk
    bytes32 constant PTR_VERSION = 0x0bf0574ec126ccd99fc2670d59004335a5c88189b4dc4c4736ba2c1eced3519c; //zeropool.instance.version
    bytes32 constant PTR_RELAYER = 0xa6c0702dad889760bc0a910159487cf57ece87c3aff39b866b8eaec3ef42f09b; //zeropool.instance.relayer

    function get_rollup_block(uint256 x) internal view returns(bytes32 value) {
        bytes32 pos = keccak256(abi.encodePacked(PTR_ROLLUP_BLOCK, x));
        value = get_bytes32(pos);
    }

    function set_rollup_block(uint256 x, bytes32 value) internal {
        bytes32 pos = keccak256(abi.encodePacked(PTR_ROLLUP_BLOCK, x));
        set_bytes32(pos, value);
    }

    function get_deposit_state(bytes32 x) internal view returns(uint256 value) {
        bytes32 pos = keccak256(abi.encodePacked(PTR_DEPOSIT_STATE, x));
        value = get_uint256(pos);
    }

    function set_deposit_state(bytes32 x, uint256 value) internal {
        bytes32 pos = keccak256(abi.encodePacked(PTR_DEPOSIT_STATE, x));
        set_uint256(pos, value);
    }



    function get_withdraw_state(bytes32 x) internal view returns(uint256 value) {
        bytes32 pos = keccak256(abi.encodePacked(PTR_WITHDRAW_STATE, x));
        value = get_uint256(pos);
    }

    function set_withdraw_state(bytes32 x, uint256 value) internal {
        bytes32 pos = keccak256(abi.encodePacked(PTR_WITHDRAW_STATE, x));
        set_uint256(pos, value);
    }



    function get_rollup_tx_num() internal view returns(uint256 value) {
        value = get_uint256(PTR_ROLLUP_TX_NUM);
    }

    function set_rollup_tx_num(uint256 value) internal {
        set_uint256(PTR_ROLLUP_TX_NUM, value);
    }

    function get_alive() internal view returns(bool value) {
        value = get_bool(PTR_ALIVE);
    }

    function set_alive(bool x) internal {
        set_bool(PTR_ALIVE, x);
    }

    function get_tx_vk() internal view virtual returns(VK memory vk) {
        vk.data = get_uint256_list(PTR_TX_VK);
    }

    function set_tx_vk(VK memory vk) internal {
        set_uint256_list(PTR_TX_VK, vk.data);
    }

    function get_tree_update_vk() internal view virtual returns(VK memory vk) {
        vk.data = get_uint256_list(PTR_TREE_UPDATE_VK);
    }

    function set_tree_update_vk(VK memory vk) internal {
        set_uint256_list(PTR_TREE_UPDATE_VK, vk.data);
    }

    function get_version() internal view returns(uint256 value) {
        value = get_uint256(PTR_VERSION);
    }

    function set_version(uint256 value) internal {
        set_uint256(PTR_VERSION, value);
    }

    function get_relayer() internal view returns(address value) {
        value = get_address(PTR_RELAYER);
    }

    function set_relayer(address value) internal {
        set_address(PTR_RELAYER, value);
    }


    modifier onlyInitialized(uint256 version) {
        require(get_version() == version, "contract should be initialized");
        _;
    }

    modifier onlyUninitialized(uint256 version) {
        require(get_version() < version, "contract should be uninitialized");
        _;
    }

    modifier onlyRelayer() {
        require(msg.sender == get_relayer(), "This is relayer-only action");
        _;
    }

    modifier onlyAlive() {
        require(get_alive(), "Contract stopped");
        _;
    }


    function blockItemNoteVerify(BlockItemNote memory note)
        internal
        view
        returns (bool)
    {
        (bytes32 itemhash, ) = blockItemHash(note.item);
        return
            MerkleProof.keccak256MerkleProof(
                note.proof,
                note.id & 0xff,
                itemhash
            ) == get_rollup_block(note.id >> 8);
    }

    function blockItemNoteVerifyPair(
        BlockItemNote memory note0,
        BlockItemNote memory note1
    ) internal view returns (bool) {
        (bytes32 itemhash0,) = blockItemHash(note0.item);
        (bytes32 itemhash1,) = blockItemHash(note1.item);


        return
            MerkleProof.keccak256MerkleProof(
                note0.proof,
                note0.id & 0xff,
                itemhash0
            ) ==
            get_rollup_block(note0.id >> 8) &&
            MerkleProof.keccak256MerkleProof(
                note1.proof,
                note1.id & 0xff,
                itemhash1
            ) ==
            get_rollup_block(note1.id >> 8) &&
            itemhash0 != itemhash1;
    }

    function blockItemHash(BlockItem memory item)
        internal
        pure
        returns (bytes32 itemhash, bytes32 txhash)
    {
        txhash = keccak256(abi.encode(item.ctx));
        itemhash = keccak256(
            abi.encode(txhash, item.new_root, item.deposit_blocknumber)
        );
    }

    function groth16verify(
        VK memory vk,
        Proof memory proof,
        uint256[] memory inputs
    ) internal view returns (bool) {
        return Groth16Verifier.verify(vk.data, proof.data, inputs);
    }

}


contract Zeropool is OptimisticRollup {
    using AbstractERC20 for IERC20;

    uint256 constant DEPOSIT_EXISTS = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    uint256 constant DEPOSIT_EXPIRES_BLOCKS = 480;
    uint256 constant CHALLENGE_EXPIRES_BLOCKS = 480;
    uint256 constant BN254_ORDER = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    uint256 constant MAX_AMOUNT = 1766847064778384329583297500742918515827483896875618958121606201292619776;

    uint256 constant VERSION = 1;

    event Deposit();
    event DepositCancel();
    event NewBlockPack();
    event Withdraw();

    function rollup_block(uint x) external view returns(bytes32) {
        return get_rollup_block(x);
    }

    function deposit_state(bytes32 x) external view returns(uint256) {
        return get_deposit_state(x);
    }

    function withdraw_state(bytes32 x) external view returns(uint256) {
        return get_withdraw_state(x);
    }

    function rollup_tx_num() external view returns(uint256) {
        return get_rollup_tx_num();
    }

    function alive() external view returns(bool) {
        return get_alive();
    }

    function tx_vk() external view returns(VK memory) {
        return get_tx_vk();
    }

    function tree_update_vk() external view returns(VK memory) {
        return get_tree_update_vk();
    }

    function relayer() external view returns(address) {
        return get_relayer();
    }

    function initialized() external view returns(bool) {
        return get_version() < VERSION;
    }

    function version() external view returns(uint256) {
        return VERSION;
    }

    function challenge_expires_blocks() external view returns(uint256) {
        return CHALLENGE_EXPIRES_BLOCKS;
    }

    function deposit_expires_blocks() external view returns(uint256) {
        return DEPOSIT_EXPIRES_BLOCKS;
    }

    
    function init(address relayer) external onlyUninitialized(VERSION) {
        set_alive(true);
        set_relayer(relayer);
        set_version(VERSION);
    }


    function deposit(IERC20 token, uint256 amount, bytes32 txhash)	//injected LOCKED ETHER
        public
        payable
        returns (bool)
    {
        uint256 _amount = token.abstractReceive(amount);
        bytes32 deposit_hash = keccak256(
            abi.encode(msg.sender, token, _amount, block.number, txhash)
        );
        set_deposit_state(deposit_hash, DEPOSIT_EXISTS);
        emit Deposit();
        return true;
    }

    function depositCancel(PayNote memory d) public returns (bool) {
        bytes32 deposit_hash = keccak256(abi.encode(d));
        require(get_deposit_state(deposit_hash) >= get_rollup_tx_num());
        require(d.blocknumber < block.number - DEPOSIT_EXPIRES_BLOCKS);
        set_deposit_state(deposit_hash, 0);
        d.utxo.token.abstractTransfer(d.utxo.owner, d.utxo.amount);
        emit DepositCancel();
        return true;
    }

    function withdraw(PayNote memory w) public returns (bool) {
        bytes32 withdraw_hash = keccak256(abi.encode(w));
        uint256 state = get_withdraw_state(withdraw_hash);
        require(state < get_rollup_tx_num() && state != 0);
        require(w.blocknumber < block.number - CHALLENGE_EXPIRES_BLOCKS);
        set_withdraw_state(withdraw_hash, 0);
        w.utxo.token.abstractTransfer(w.utxo.owner, w.utxo.amount);
        emit Withdraw();
        return true;
    }

    function publishBlock(
        uint256 protocol_version,
        BlockItem[] memory items,
        uint256 rollup_cur_block_num,
        uint256 blocknumber_expires
    ) public onlyRelayer onlyAlive returns (bool) {
        uint256 cur_rollup_tx_num = get_rollup_tx_num();

        require(rollup_cur_block_num == cur_rollup_tx_num >> 8, "wrong block number");
        require(protocol_version == get_version(), "wrong protocol version");
        require(block.number < blocknumber_expires, "blocknumber is already expires");
        uint256 nitems = items.length;
        require(nitems > 0 && nitems <= 256, "wrong number of items");
        bytes32[] memory hashes = new bytes32[](nitems); 
        for (uint256 i = 0; i < nitems; i++) {
            BlockItem memory item = items[i];
            bytes32 itemhash = keccak256(abi.encode(item));
            if (item.ctx.delta == 0) {
                require(item.deposit_blocknumber == 0, "deposit_blocknumber should be zero in transfer case");
                require(item.ctx.token == IERC20(0), "token should be zero in transfer case");
                require(item.ctx.ext.owner == address(0), "owner should be zero in tranfer case");
            } else if (item.ctx.delta < MAX_AMOUNT) {
                bytes32 txhash = keccak256(abi.encode(item.ctx));
                bytes32 deposit_hash = keccak256(
                    abi.encode(
                        item.ctx.ext.owner,
                        item.ctx.token,
                        item.ctx.delta,
                        item.deposit_blocknumber,
                        txhash
                    )
                );
                require(get_deposit_state(deposit_hash) == DEPOSIT_EXISTS, "unexisted deposit");
                set_deposit_state(deposit_hash, cur_rollup_tx_num + i);
            } else if (
                item.ctx.delta > BN254_ORDER - MAX_AMOUNT &&
                item.ctx.delta < BN254_ORDER
            ) {
                require(item.deposit_blocknumber == 0, "deposit blocknumber should be zero");
                bytes32 txhash = keccak256(abi.encode(item.ctx));
                bytes32 withdraw_hash = keccak256(
                    abi.encode(
                        item.ctx.ext.owner,
                        item.ctx.token,
                        BN254_ORDER - item.ctx.delta,
                        block.number,
                        txhash
                    )
                );
                require(get_withdraw_state(withdraw_hash) == 0, "withdrawal already published");
                set_withdraw_state(withdraw_hash, cur_rollup_tx_num + i);
            } else revert("wrong behavior");

            hashes[i] = itemhash;
        }
        set_rollup_block(cur_rollup_tx_num >> 8, MerkleProof.keccak256MerkleTree(hashes));
        set_rollup_tx_num(cur_rollup_tx_num+256);
        emit NewBlockPack();
        return true;
    }

    function stopRollup(uint256 lastvalid) internal returns (bool) {
        set_alive(false);
        if (get_rollup_tx_num() > lastvalid) set_rollup_tx_num(lastvalid);
    }

    function challengeTx(BlockItemNote memory cur, BlockItemNote memory base)
        public
        returns (bool)
    {
        require(blockItemNoteVerifyPair(cur, base));
        require(cur.item.ctx.rootptr == base.id);
        uint256[] memory inputs = new uint256[](8);
        inputs[0] = base.item.new_root;
        inputs[1] = cur.item.ctx.nullifier[0];
        inputs[2] = cur.item.ctx.nullifier[1];
        inputs[3] = cur.item.ctx.utxo[0];
        inputs[4] = cur.item.ctx.utxo[1];
        inputs[5] = uint256(address(cur.item.ctx.token));
        inputs[6] = cur.item.ctx.delta;
        inputs[7] = uint256(keccak256(abi.encode(cur.item.ctx.ext))) % BN254_ORDER;
        require(
            !groth16verify(get_tx_vk(), cur.item.ctx.proof, inputs) ||
                cur.item.ctx.rootptr >= cur.id
        );
        stopRollup(
            cur.id &
                0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00
        );
        return true;
    }

    function challengeUTXOTreeUpdate(
        BlockItemNote memory cur,
        BlockItemNote memory prev,
        uint256 right_root
    ) public returns (bool) {
        require(blockItemNoteVerifyPair(cur, prev));
        require(right_root != cur.item.new_root);
        require(cur.id == prev.id + 1);
        uint256[] memory inputs = new uint256[](5);
        inputs[0] = prev.item.new_root;
        inputs[1] = right_root;
        inputs[2] = cur.id;
        inputs[3] = cur.item.ctx.utxo[0];
        inputs[4] = cur.item.ctx.utxo[1];
        require(groth16verify(get_tree_update_vk(), cur.item.ctx.proof, inputs));
        stopRollup(
            cur.id &
                0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00
        );
        return true;
    }


    function challengeDoubleSpend(
        BlockItemNote memory cur,
        BlockItemNote memory prev
    ) public returns (bool) {
        require(blockItemNoteVerifyPair(cur, prev));
        require(cur.id > prev.id);
        require(
            cur.item.ctx.nullifier[0] == prev.item.ctx.nullifier[0] ||
                cur.item.ctx.nullifier[0] == prev.item.ctx.nullifier[1] ||
                cur.item.ctx.nullifier[1] == prev.item.ctx.nullifier[0] ||
                cur.item.ctx.nullifier[1] == prev.item.ctx.nullifier[1]
        );
        stopRollup(
            cur.id &
                0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00
        );
        return true;
    }

// generated verification keys

function get_tx_vk() internal view override returns(VK memory vk) {
    vk.data = new uint256[](32);
	vk.data[0]=16697396276845359349763623132880681261946057173403665684116014317021563254655;
	vk.data[1]=5587233253515298594979379376112193939999977226319827083400780508947632238748;
	vk.data[2]=996344031357008752188061777727343821194999038419356867329464288563909617005;
	vk.data[3]=19290932987249234962967288959963528407103065644647211765713208264341394525627;
	vk.data[4]=8553749439216169983700315269252703464956761305522445870304892856460243321047;
	vk.data[5]=7499331826236872853986916310426702508083585717393534257027110568354271287432;
	vk.data[6]=17818442198315603854906648488684700215588900049016248299047528035268326306021;
	vk.data[7]=15742330311792086244154238527312139581390392470409527670106624318539491230639;
	vk.data[8]=15582884393435508760323520593128472668109949438533129736977260887861833544686;
	vk.data[9]=21497591859374664749646772170336511135502780606163622402006911936080711585567;
	vk.data[10]=7790006490742208514342359392548790920526758492331804655644059775462847493097;
	vk.data[11]=13129551538859899483631249619546540237894645124538636048121349380930189507838;
	vk.data[12]=4746286819103243220536118278269041624087200484408004244046357476009810846546;
	vk.data[13]=18658744770115522082166315751608350375192957102952937317896374405594493134526;
	vk.data[14]=19989489438779009436306295034063506403791061054909758505826349901018217062148;
	vk.data[15]=12423258039559374001195155548721642852023802830208605918786258373002084367632;
	vk.data[16]=7003237418971344613051082595005151675497565165987117592967572800525158824489;
	vk.data[17]=7974534769221088592950139635833940989569216922408396815015576367720824241508;
	vk.data[18]=11849446094135848442330464397836476735986056048931041670863652298683592522299;
	vk.data[19]=5688048430194407294094808809106358923767040643882276446273178191473705984722;
	vk.data[20]=15251866809401758881597063825677390012089302300318896335505843954313586308460;
	vk.data[21]=382122240772754036035492924033721102122148609052952215005785336028904779974;
	vk.data[22]=10812902853773819225346776822522835276124447801378031518741367874851505049128;
	vk.data[23]=5441632396550715758039364769225858885484351780111874540894325037632766747975;
	vk.data[24]=15786403199430745833044642273676411893860838678282184591801848247162444177171;
	vk.data[25]=8656349755733447799905795854043134530429068654454399761530913385689890843892;
	vk.data[26]=16208788594254936587671118621629101795259918519956251673155645395337803398644;
	vk.data[27]=11008397050768236649236829775384097670794106671173713047158085580508730412294;
	vk.data[28]=5000535825997546131883098495344030668482959620659549513047593209192484024554;
	vk.data[29]=6037131813824258546352206109740790709325012719822508419478741594076251165562;
	vk.data[30]=232537091421478948749164191800530205602104220622818161892691965271681780444;
	vk.data[31]=8541890110169324141024763602672843893521937974195030991302885883209417356350;

}

function get_tree_update_vk() internal view override returns(VK memory vk) {
    vk.data = new uint256[](26);
	vk.data[0]=1117561174711447970699783508540835969335571306961098817222886978948744345711;
	vk.data[1]=10780325785780371097555321883689276320673547412863821024704236163981475185231;
	vk.data[2]=9190339596842207972698547696205148463284800225991013839726333455510728418061;
	vk.data[3]=2787003181019705527994114183958804481617926021310039402048478633993643050257;
	vk.data[4]=19025462432212307115968461300130326702118822938799182787816944256592782469896;
	vk.data[5]=13374329695938559341973106697972813681348489436576893374756555356012735204935;
	vk.data[6]=2391540205558897324637905451340679985349421498010435945591140422554529899138;
	vk.data[7]=4538034768061760463973814808256573325692419571060079531866609248139564624084;
	vk.data[8]=1676495264895295799704478861413793414754594619949871821864061782072790895386;
	vk.data[9]=14126847152901573392009992091969331199931177575536794424151289240625771346641;
	vk.data[10]=17538580900482196889842913547024185367722169963653894198473788114352852534451;
	vk.data[11]=8190411413825327934159222466106546022021029229252021910318976779844785663832;
	vk.data[12]=10967610977689797074852479085031480141553081046525341474335007496946965996889;
	vk.data[13]=7518076114965605632016029983105922598125144277731467379298374011599641312871;
	vk.data[14]=12707371020099695894329449101665177001847210301388750083164379479457407482586;
	vk.data[15]=9638979230410286344537095100035451133751102850514918826098902859896696414299;
	vk.data[16]=8486153680023739150613783925554306655861399968866354186425033515785337545045;
	vk.data[17]=4326081295507141428403366893493945239683826229496173558026196418081249993919;
	vk.data[18]=15025661877684012486667234299497831337050778534199450729135536609646068791727;
	vk.data[19]=10170327312676973089401561543622362963624936244289159008674890415147237746815;
	vk.data[20]=8249238187438221843102710918896640046224395740564573077618681767459880159151;
	vk.data[21]=19333329033893998261051692597725252825459050054888992926855629308261440687681;
	vk.data[22]=9410494220927663013897883141562056814411016181471810870390609726747759553716;
	vk.data[23]=6569431686535661164713601709252422249188606253902167941201140375618464568594;
	vk.data[24]=12006374143171123543831491679354588477211042045298704251427754348688205712072;
	vk.data[25]=11397989004848280683211927657137052100877146185703927010611549774118733967444;

}



}