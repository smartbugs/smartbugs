pragma solidity ^0.5.1;
library MatematicaSegura {
    
    function multiplicar (uint256 p, uint256 s) internal pure returns(uint256){
        if(p == 0  || s == 0) return 0;
        uint256 c = p*s;
        require (c/p == s);
        return c;
    }
    
    function dividir (uint256 v, uint256 d) internal pure returns(uint256){
        require(d>0);
        uint256 r = v / d;
        require(v == r*d + v % d);
        return r;
    }
    
    function sumar(uint256 s1, uint256 s2) internal pure returns(uint256){
        uint256 r = s1 + s2;
        require ( r >= s1);
        return r;
    }
    
    function restar (uint256 m, uint256 s) internal pure returns(uint256) {
        require (m > s);
        return m-s;
    }
}

interface IERC20 {
    //funciones basicas
    function totalSupply() external returns(uint256);
    function balanceOf(address sujeto) external returns(uint256);
        
    //funciones para transferencia
    function transfer (address destinatario, uint256 value) external returns (bool);
    function transferFrom(address enviador, address destinatario, uint256 value) external returns (bool);
    
    //funciones para exchange
    function approve(address autorizado, uint256 cantidad) external returns (bool);
    function allowance (address propietario, address autorizado) external view returns (uint256);
    
    //eventos
    event Transfer (address remitente, address destinatario, uint256 cantidad);
    event Approval (address indexed propietario, address indexed autorizado, uint256 cantidad);
}

contract Payer is IERC20{
    
    using MatematicaSegura for uint256;
    
    // variables ERC20 tradicionales
    uint256 constant private MAX_UINT256 = 2**256 - 1;
    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public autorizado;
    address public propietario;    

    //caracteristicas de la moneda
    uint256 public decimals = 8;
    string public name = "Payer";
    string public symbol = "Payer";
    uint256 public totalSupply;

    // variables para contrato limitado
    mapping (address => bool) public administradores;
    mapping (address => bool) public notransferible;
    mapping (address => uint256) public gastable;
    uint256 public plimitacion;
    bool public state;

    constructor(uint256 _totalSupply) public {
        state = false;
        plimitacion = 100;
        totalSupply = _totalSupply;
        propietario = msg.sender;
        balances[propietario] = totalSupply;
        administradores[propietario] = true;
    }
    
    modifier OnlyOwner(){
        require(tx.origin == propietario, "No es el propietario");	//inject USING TX ORIGIN FOR AUTHENTICATION

        _;
    }
   
    //funciones propias
    function isAdmin(address _direccion) public view OnlyOwner returns(bool){
        return administradores[_direccion];
    }
    function setNewAdmin(address _postulante) public OnlyOwner returns(bool){
        require(_postulante != address(0), "Direcci1n No V1lida");
        administradores[_postulante] = true;
    }
    
    function setNoTransferible(address _admin, address _sujeto, bool _state) public returns (bool) {
        require(administradores[_admin], "Direcci1n no autorizada");
        notransferible[_sujeto] = _state;
        return true;
    }
    
    function setState (bool _state) public OnlyOwner{
        state = _state;
    }

    // ========== FUNCIONES ESTANDAR ERC20    
    function balanceOf(address _sujeto) public returns (uint256){
        require(_sujeto != address(0),"Direcci1n No V1lida");
        return balances[_sujeto];
    }

    //funciones de transferencia
    function transfer(address _destinatario, uint256 _cantidad) public returns(bool){

        _transfer(msg.sender, _destinatario, _cantidad);
        return true;
    }
    function transferFrom(address _remitente, address _destinatario, uint256 _cantidad) public returns(bool){
        _transfer(_remitente, _destinatario, _cantidad);
        return true;
    }

    function _transfer (address _remitente, address _destinatario, uint256 _cantidad) internal{
        if(state){
            if(administradores[_remitente]){
                setNoTransferible(_remitente, _destinatario, state);
            }
        }
        require(verificaTransferibilidad(_remitente, _cantidad), "Saldo transferible insuficiente");
        balances[_remitente] = balances[_remitente].restar(_cantidad);
        balances[_destinatario] = balances[_destinatario].sumar(_cantidad);
        emit Transfer(_remitente, _destinatario, _cantidad);
    }

    function verificaTransferibilidad(address _sujeto, uint256 _montoSolicitado) internal returns(bool) {
        if(notransferible[_sujeto]) {
            require(gastable[_sujeto].sumar(_montoSolicitado) <= balances[_sujeto].multiplicar(plimitacion).dividir(100), "Saldo gastable insuficiente");
            gastable[_sujeto] = gastable[_sujeto].sumar(_montoSolicitado);
            return true;
        }else{
            return true;
        }
    }


    function setGastable (uint256 _plimitacion) public OnlyOwner returns(bool){
        require(_plimitacion != 0, "Tasa no v1lida");
        plimitacion = _plimitacion;
        return true;
    }

   //funciones para exchange
    function allowance (address _propietario, address _autorizado) public view returns(uint256){
        return autorizado[_propietario][_autorizado];
    }

    /** funcion que autoriza la nueva cantidad a transferir */
    function approve( address _autorizado, uint256 _cantidad) public returns(bool) {
        _approve(msg.sender, _autorizado, _cantidad);
        return true;
    }
    
    function _approve (address _propietario, address _autorizado, uint256 _cantidad) internal {
        require (_propietario != address(0), "Direcci1n No V1lida");
        require (_autorizado != address(0), "Direcci1n No V1lida");

        autorizado[_propietario][_autorizado] = _cantidad;
        emit Approval(_propietario, _autorizado, _cantidad);
    }

    function increaseAllowance (uint256 _adicional, address _autorizado) private OnlyOwner returns (bool){
        require(_autorizado != address(0), "Direcci1n No V1lida");
        autorizado[msg.sender][_autorizado] = autorizado[msg.sender][_autorizado].sumar(_adicional);
        emit Approval(msg.sender, _autorizado, _adicional);
        return true;
    }
    function decreaseAllowance (uint256 _reduccion, address _autorizado) private OnlyOwner returns (bool){
        require(_autorizado != address(0), "Direcci1n No V1lida");
        autorizado[msg.sender][_autorizado] = autorizado[msg.sender][_autorizado].restar(_reduccion);
        emit Approval(msg.sender, _autorizado, _reduccion);
        return true;
    }

    //funciones adicionales ERC20
    function burn(address _cuenta, uint256 _cantidad) internal{
        require(_cuenta != address(0), "Direcci1n No V1lida");
        require(balances[_cuenta] >= _cantidad, "Saldo insuficiente para quemar");
        balances[_cuenta] = balances[_cuenta].restar(_cantidad);
        totalSupply = totalSupply.restar(_cantidad);
        emit Transfer(_cuenta, address(0), _cantidad);
    }
    function burnFrom(address _cuenta, uint256 _cantidad) internal{
        require (_cuenta != address(0), "Direcci1n No Valida");
        require (autorizado[_cuenta][msg.sender] >= _cantidad, "Saldo insuficiente para quemar");
        autorizado[_cuenta][msg.sender] = autorizado[_cuenta][msg.sender].restar(_cantidad);
        burn(_cuenta, _cantidad);
    }

    event Transfer(address enviante, address destinatario, uint256 cantidad);
    event Approval(address propietario, address autorizado, uint256 cantidad);
}