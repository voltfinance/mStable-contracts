// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.8.2;

interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IERC4626Vault is IERC20 {
    /// @notice The address of the underlying token used for the Vault uses for accounting, depositing, and withdrawing
    function asset() external view returns (address assetTokenAddress);

    /// @notice Total amount of the underlying asset that is “managed” by Vault
    function totalAssets() external view returns (uint256 totalManagedAssets);

    /**
     * @notice The amount of shares that the Vault would exchange for the amount of assets provided, in an ideal scenario where all the conditions are met.
     * @param assets The amount of underlying assets to be convert to vault shares.
     * @return shares The amount of vault shares converted from the underlying assets.
     */
    function convertToShares(uint256 assets) external view returns (uint256 shares);

    /**
     * @notice The amount of assets that the Vault would exchange for the amount of shares provided, in an ideal scenario where all the conditions are met.
     * @param shares The amount of vault shares to be converted to the underlying assets.
     * @return assets The amount of underlying assets converted from the vault shares.
     */
    function convertToAssets(uint256 shares) external view returns (uint256 assets);

    /**
     * @notice The maximum number of underlying assets that caller can deposit.
     * @param caller Account that the assets will be transferred from.
     * @return maxAssets The maximum amount of underlying assets the caller can deposit.
     */
    function maxDeposit(address caller) external view returns (uint256 maxAssets);

    /**
     * @notice Allows an on-chain or off-chain user to simulate the effects of their deposit at the current block, given current on-chain conditions.
     * @param assets The amount of underlying assets to be transferred.
     * @return shares The amount of vault shares that will be minted.
     */
    function previewDeposit(uint256 assets) external view returns (uint256 shares);

    /**
     * @notice Mint vault shares to receiver by transferring exact amount of underlying asset tokens from the caller.
     * @param assets The amount of underlying assets to be transferred to the vault.
     * @param receiver The account that the vault shares will be minted to.
     * @return shares The amount of vault shares that were minted.
     */
    function deposit(uint256 assets, address receiver) external returns (uint256 shares);

    /**
     * @notice The maximum number of vault shares that caller can mint.
     * @param caller Account that the underlying assets will be transferred from.
     * @return maxShares The maximum amount of vault shares the caller can mint.
     */
    function maxMint(address caller) external view returns (uint256 maxShares);

    /**
     * @notice Allows an on-chain or off-chain user to simulate the effects of their mint at the current block, given current on-chain conditions.
     * @param shares The amount of vault shares to be minted.
     * @return assets The amount of underlying assests that will be transferred from the caller.
     */
    function previewMint(uint256 shares) external view returns (uint256 assets);

    /**
     * @notice Mint exact amount of vault shares to the receiver by transferring enough underlying asset tokens from the caller.
     * @param shares The amount of vault shares to be minted.
     * @param receiver The account the vault shares will be minted to.
     * @return assets The amount of underlying assets that were transferred from the caller.
     */
    function mint(uint256 shares, address receiver) external returns (uint256 assets);

    /**
     * @notice The maximum number of underlying assets that owner can withdraw.
     * @param owner Account that owns the vault shares.
     * @return maxAssets The maximum amount of underlying assets the owner can withdraw.
     */
    function maxWithdraw(address owner) external view returns (uint256 maxAssets);

    /**
     * @notice Allows an on-chain or off-chain user to simulate the effects of their withdrawal at the current block, given current on-chain conditions.
     * @param assets The amount of underlying assets to be withdrawn.
     * @return shares The amount of vault shares that will be burnt.
     */
    function previewWithdraw(uint256 assets) external view returns (uint256 shares);

    /**
     * @notice Burns enough vault shares from owner and transfers the exact amount of underlying asset tokens to the receiver.
     * @param assets The amount of underlying assets to be withdrawn from the vault.
     * @param receiver The account that the underlying assets will be transferred to.
     * @param owner Account that owns the vault shares to be burnt.
     * @return shares The amount of vault shares that were burnt.
     */
    function withdraw(
        uint256 assets,
        address receiver,
        address owner
    ) external returns (uint256 shares);

    /**
     * @notice The maximum number of shares an owner can redeem for underlying assets.
     * @param owner Account that owns the vault shares.
     * @return maxShares The maximum amount of shares the owner can redeem.
     */
    function maxRedeem(address owner) external view returns (uint256 maxShares);

    /**
     * @notice Allows an on-chain or off-chain user to simulate the effects of their redeemption at the current block, given current on-chain conditions.
     * @param shares The amount of vault shares to be burnt.
     * @return assets The amount of underlying assests that will transferred to the receiver.
     */
    function previewRedeem(uint256 shares) external view returns (uint256 assets);

    /**
     * @notice Burns exact amount of vault shares from owner and transfers the underlying asset tokens to the receiver.
     * @param shares The amount of vault shares to be burnt.
     * @param receiver The account the underlying assets will be transferred to.
     * @param owner The account that owns the vault shares to be burnt.
     * @return assets The amount of underlying assets that were transferred to the receiver.
     */
    function redeem(
        uint256 shares,
        address receiver,
        address owner
    ) external returns (uint256 assets);

    /*///////////////////////////////////////////////////////////////
                                Events
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev Emitted when caller has exchanged assets for shares, and transferred those shares to owner.
     *
     * Note It must be emitted when tokens are deposited into the Vault in ERC4626.mint or ERC4626.deposit methods.
     *
     */
    event Deposit(address indexed caller, address indexed owner, uint256 assets, uint256 shares);
    /**
     * @dev Emitted when sender has exchanged shares for assets, and transferred those assets to receiver.
     *
     * Note It must be emitted when shares are withdrawn from the Vault in ERC4626.redeem or ERC4626.withdraw methods.
     *
     */
    event Withdraw(
        address indexed caller,
        address indexed receiver,
        address indexed owner,
        uint256 assets,
        uint256 shares
    );
}

interface IUnwrapper {
    // @dev Get bAssetOut status
    function getIsBassetOut(
        address _masset,
        bool _inputIsCredit,
        address _output
    ) external view returns (bool isBassetOut);

    /// @dev Estimate output
    function getUnwrapOutput(
        bool _isBassetOut,
        address _router,
        address _input,
        bool _inputIsCredit,
        address _output,
        uint256 _amount
    ) external view returns (uint256 output);

    /// @dev Unwrap and send
    function unwrapAndSend(
        bool _isBassetOut,
        address _router,
        address _input,
        address _output,
        uint256 _amount,
        uint256 _minAmountOut,
        address _beneficiary
    ) external returns (uint256 outputQuantity);
}

interface ISavingsManager {
    /** @dev Admin privs */
    function distributeUnallocatedInterest(address _mAsset) external;

    /** @dev Liquidator */
    function depositLiquidation(address _mAsset, uint256 _liquidation) external;

    /** @dev Liquidator */
    function collectAndStreamInterest(address _mAsset) external;

    /** @dev Public privs */
    function collectAndDistributeInterest(address _mAsset) external;

    /** @dev getter for public lastBatchCollected mapping */
    function lastBatchCollected(address _mAsset) external view returns (uint256);
}

interface ISavingsContractV4 is
    IERC4626Vault // V4
{
    // DEPRECATED but still backwards compatible
    function redeem(uint256 _amount) external returns (uint256 massetReturned);

    function creditBalances(address) external view returns (uint256); // V1 & V2 (use balanceOf)

    // --------------------------------------------

    function depositInterest(uint256 _amount) external; // V1 & V2

    function depositSavings(uint256 _amount) external returns (uint256 creditsIssued); // V1 & V2

    function depositSavings(uint256 _amount, address _beneficiary)
        external
        returns (uint256 creditsIssued); // V2

    function redeemCredits(uint256 _amount) external returns (uint256 underlyingReturned); // V2

    function redeemUnderlying(uint256 _amount) external returns (uint256 creditsBurned); // V2

    function exchangeRate() external view returns (uint256); // V1 & V2

    function balanceOfUnderlying(address _user) external view returns (uint256 balance); // V2

    function underlyingToCredits(uint256 _credits) external view returns (uint256 underlying); // V2

    function creditsToUnderlying(uint256 _underlying) external view returns (uint256 credits); // V2

    function redeemAndUnwrap(
        uint256 _amount,
        bool _isCreditAmt,
        uint256 _minAmountOut,
        address _output,
        address _beneficiary,
        address _router,
        bool _isBassetOut
    )
        external
        returns (
            uint256 creditsBurned,
            uint256 massetRedeemed,
            uint256 outputQuantity
        );

    function depositSavings(
        uint256 _underlying,
        address _beneficiary,
        address _referrer
    ) external returns (uint256 creditsIssued);

    // -------------------------------------------- V4
    function deposit(
        uint256 assets,
        address receiver,
        address referrer
    ) external returns (uint256 shares);

    function mint(
        uint256 shares,
        address receiver,
        address referrer
    ) external returns (uint256 assets);
}

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    // constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract ERC205 is Context, IERC20 {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        _approve(sender, _msgSender(), currentAllowance - amount);

        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        _approve(_msgSender(), spender, currentAllowance - subtractedValue);

        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        _balances[sender] = senderBalance - amount;
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        _balances[account] = accountBalance - amount;
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}

abstract contract InitializableERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
     * these values are immutable: they can only be set once during
     * construction.
     * @notice To avoid variable shadowing appended `Arg` after arguments name.
     */
    function _initialize(
        string memory nameArg,
        string memory symbolArg,
        uint8 decimalsArg
    ) internal {
        _name = nameArg;
        _symbol = symbolArg;
        _decimals = decimalsArg;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }
}

abstract contract InitializableToken is ERC205, InitializableERC20Detailed {
    /**
     * @dev Initialization function for implementing contract
     * @notice To avoid variable shadowing appended `Arg` after arguments name.
     */
    function _initialize(string memory _nameArg, string memory _symbolArg) internal {
        InitializableERC20Detailed._initialize(_nameArg, _symbolArg, 18);
    }
}

contract ModuleKeys {
    // Governance
    // ===========
    // keccak256("Governance");
    bytes32 internal constant KEY_GOVERNANCE =
        0x9409903de1e6fd852dfc61c9dacb48196c48535b60e25abf92acc92dd689078d;
    //keccak256("Staking");
    bytes32 internal constant KEY_STAKING =
        0x1df41cd916959d1163dc8f0671a666ea8a3e434c13e40faef527133b5d167034;
    //keccak256("ProxyAdmin");
    bytes32 internal constant KEY_PROXY_ADMIN =
        0x96ed0203eb7e975a4cbcaa23951943fa35c5d8288117d50c12b3d48b0fab48d1;

    // mStable
    // =======
    // keccak256("OracleHub");
    bytes32 internal constant KEY_ORACLE_HUB =
        0x8ae3a082c61a7379e2280f3356a5131507d9829d222d853bfa7c9fe1200dd040;
    // keccak256("Manager");
    bytes32 internal constant KEY_MANAGER =
        0x6d439300980e333f0256d64be2c9f67e86f4493ce25f82498d6db7f4be3d9e6f;
    //keccak256("Recollateraliser");
    bytes32 internal constant KEY_RECOLLATERALISER =
        0x39e3ed1fc335ce346a8cbe3e64dd525cf22b37f1e2104a755e761c3c1eb4734f;
    //keccak256("MetaToken");
    bytes32 internal constant KEY_META_TOKEN =
        0xea7469b14936af748ee93c53b2fe510b9928edbdccac3963321efca7eb1a57a2;
    // keccak256("SavingsManager");
    bytes32 internal constant KEY_SAVINGS_MANAGER =
        0x12fe936c77a1e196473c4314f3bed8eeac1d757b319abb85bdda70df35511bf1;
    // keccak256("Liquidator");
    bytes32 internal constant KEY_LIQUIDATOR =
        0x1e9cb14d7560734a61fa5ff9273953e971ff3cd9283c03d8346e3264617933d4;
    // keccak256("InterestValidator");
    bytes32 internal constant KEY_INTEREST_VALIDATOR =
        0xc10a28f028c7f7282a03c90608e38a4a646e136e614e4b07d119280c5f7f839f;
}

interface INexus {
    function governor() external view returns (address);

    function getModule(bytes32 key) external view returns (address);

    function proposeModule(bytes32 _key, address _addr) external;

    function cancelProposedModule(bytes32 _key) external;

    function acceptProposedModule(bytes32 _key) external;

    function acceptProposedModules(bytes32[] calldata _keys) external;

    function requestLockModule(bytes32 _key) external;

    function cancelLockModule(bytes32 _key) external;

    function lockModule(bytes32 _key) external;
}

abstract contract ImmutableModule is ModuleKeys {
    INexus public immutable nexus;

    /**
     * @dev Initialization function for upgradable proxy contracts
     * @param _nexus Nexus contract address
     */
    constructor(address _nexus) {
        require(_nexus != address(0), "Nexus address is zero");
        nexus = INexus(_nexus);
    }

    /**
     * @dev Modifier to allow function calls only from the Governor.
     */
    modifier onlyGovernor() {
        _onlyGovernor();
        _;
    }

    function _onlyGovernor() internal view {
        require(msg.sender == _governor(), "Only governor can execute");
    }

    /**
     * @dev Modifier to allow function calls only from the Governance.
     *      Governance is either Governor address or Governance address.
     */
    modifier onlyGovernance() {
        require(
            msg.sender == _governor() || msg.sender == _governance(),
            "Only governance can execute"
        );
        _;
    }

    /**
     * @dev Returns Governor address from the Nexus
     * @return Address of Governor Contract
     */
    function _governor() internal view returns (address) {
        return nexus.governor();
    }

    /**
     * @dev Returns Governance Module address from the Nexus
     * @return Address of the Governance (Phase 2)
     */
    function _governance() internal view returns (address) {
        return nexus.getModule(KEY_GOVERNANCE);
    }

    /**
     * @dev Return SavingsManager Module address from the Nexus
     * @return Address of the SavingsManager Module contract
     */
    function _savingsManager() internal view returns (address) {
        return nexus.getModule(KEY_SAVINGS_MANAGER);
    }

    /**
     * @dev Return Recollateraliser Module address from the Nexus
     * @return  Address of the Recollateraliser Module contract (Phase 2)
     */
    function _recollateraliser() internal view returns (address) {
        return nexus.getModule(KEY_RECOLLATERALISER);
    }

    /**
     * @dev Return Recollateraliser Module address from the Nexus
     * @return  Address of the Recollateraliser Module contract (Phase 2)
     */
    function _liquidator() internal view returns (address) {
        return nexus.getModule(KEY_LIQUIDATOR);
    }

    /**
     * @dev Return ProxyAdmin Module address from the Nexus
     * @return Address of the ProxyAdmin Module contract
     */
    function _proxyAdmin() internal view returns (address) {
        return nexus.getModule(KEY_PROXY_ADMIN);
    }
}

interface IConnector {
    /**
     * @notice Deposits the mAsset into the connector
     * @param _amount Units of mAsset to receive and deposit
     */
    function deposit(uint256 _amount) external;

    /**
     * @notice Withdraws a specific amount of mAsset from the connector
     * @param _amount Units of mAsset to withdraw
     */
    function withdraw(uint256 _amount) external;

    /**
     * @notice Withdraws all mAsset from the connector
     */
    function withdrawAll() external;

    /**
     * @notice Returns the available balance in the connector. In connections
     * where there is likely to be an initial dip in value due to conservative
     * exchange rates (e.g. with Curves `get_virtual_price`), it should return
     * max(deposited, balance) to avoid temporary negative yield. Any negative yield
     * should be corrected during a withdrawal or over time.
     * @return Balance of mAsset in the connector
     */
    function checkBalance() external view returns (uint256);
}

contract Initializable {
    /**
     * @dev Indicates that the contract has been initialized.
     */
    bool private initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private initializing;

    /**
     * @dev Modifier to use in the initializer function of a contract.
     */
    modifier initializer() {
        require(
            initializing || isConstructor() || !initialized,
            "Contract instance has already been initialized"
        );

        bool isTopLevelCall = !initializing;
        if (isTopLevelCall) {
            initializing = true;
            initialized = true;
        }

        _;

        if (isTopLevelCall) {
            initializing = false;
        }
    }

    /// @dev Returns true if and only if the function is running in the constructor
    function isConstructor() private view returns (bool) {
        // extcodesize checks the size of the code stored in an address, and
        // address returns the current address. Since the code is still not
        // deployed when running a constructor, any checks on its code size will
        // yield zero, making it an effective way to detect if a contract is
        // under construction or not.
        address self = address(this);
        uint256 cs;
        assembly {
            cs := extcodesize(self)
        }
        return cs == 0;
    }

    // Reserved storage space to allow for layout changes in the future.
    uint256[50] private ______gap;
}

library StableMath {
    /**
     * @dev Scaling unit for use in specific calculations,
     * where 1 * 10**18, or 1e18 represents a unit '1'
     */
    uint256 private constant FULL_SCALE = 1e18;

    /**
     * @dev Token Ratios are used when converting between units of bAsset, mAsset and MTA
     * Reasoning: Takes into account token decimals, and difference in base unit (i.e. grams to Troy oz for gold)
     * bAsset ratio unit for use in exact calculations,
     * where (1 bAsset unit * bAsset.ratio) / ratioScale == x mAsset unit
     */
    uint256 private constant RATIO_SCALE = 1e8;

    /**
     * @dev Provides an interface to the scaling unit
     * @return Scaling unit (1e18 or 1 * 10**18)
     */
    function getFullScale() internal pure returns (uint256) {
        return FULL_SCALE;
    }

    /**
     * @dev Provides an interface to the ratio unit
     * @return Ratio scale unit (1e8 or 1 * 10**8)
     */
    function getRatioScale() internal pure returns (uint256) {
        return RATIO_SCALE;
    }

    /**
     * @dev Scales a given integer to the power of the full scale.
     * @param x   Simple uint256 to scale
     * @return    Scaled value a to an exact number
     */
    function scaleInteger(uint256 x) internal pure returns (uint256) {
        return x * FULL_SCALE;
    }

    /***************************************
              PRECISE ARITHMETIC
    ****************************************/

    /**
     * @dev Multiplies two precise units, and then truncates by the full scale
     * @param x     Left hand input to multiplication
     * @param y     Right hand input to multiplication
     * @return      Result after multiplying the two inputs and then dividing by the shared
     *              scale unit
     */
    function mulTruncate(uint256 x, uint256 y) internal pure returns (uint256) {
        return mulTruncateScale(x, y, FULL_SCALE);
    }

    /**
     * @dev Multiplies two precise units, and then truncates by the given scale. For example,
     * when calculating 90% of 10e18, (10e18 * 9e17) / 1e18 = (9e36) / 1e18 = 9e18
     * @param x     Left hand input to multiplication
     * @param y     Right hand input to multiplication
     * @param scale Scale unit
     * @return      Result after multiplying the two inputs and then dividing by the shared
     *              scale unit
     */
    function mulTruncateScale(
        uint256 x,
        uint256 y,
        uint256 scale
    ) internal pure returns (uint256) {
        // e.g. assume scale = fullScale
        // z = 10e18 * 9e17 = 9e36
        // return 9e38 / 1e18 = 9e18
        return (x * y) / scale;
    }

    /**
     * @dev Multiplies two precise units, and then truncates by the full scale, rounding up the result
     * @param x     Left hand input to multiplication
     * @param y     Right hand input to multiplication
     * @return      Result after multiplying the two inputs and then dividing by the shared
     *              scale unit, rounded up to the closest base unit.
     */
    function mulTruncateCeil(uint256 x, uint256 y) internal pure returns (uint256) {
        // e.g. 8e17 * 17268172638 = 138145381104e17
        uint256 scaled = x * y;
        // e.g. 138145381104e17 + 9.99...e17 = 138145381113.99...e17
        uint256 ceil = scaled + FULL_SCALE - 1;
        // e.g. 13814538111.399...e18 / 1e18 = 13814538111
        return ceil / FULL_SCALE;
    }

    /**
     * @dev Precisely divides two units, by first scaling the left hand operand. Useful
     *      for finding percentage weightings, i.e. 8e18/10e18 = 80% (or 8e17)
     * @param x     Left hand input to division
     * @param y     Right hand input to division
     * @return      Result after multiplying the left operand by the scale, and
     *              executing the division on the right hand input.
     */
    function divPrecisely(uint256 x, uint256 y) internal pure returns (uint256) {
        // e.g. 8e18 * 1e18 = 8e36
        // e.g. 8e36 / 10e18 = 8e17
        return (x * FULL_SCALE) / y;
    }

    /***************************************
                  RATIO FUNCS
    ****************************************/

    /**
     * @dev Multiplies and truncates a token ratio, essentially flooring the result
     *      i.e. How much mAsset is this bAsset worth?
     * @param x     Left hand operand to multiplication (i.e Exact quantity)
     * @param ratio bAsset ratio
     * @return c    Result after multiplying the two inputs and then dividing by the ratio scale
     */
    function mulRatioTruncate(uint256 x, uint256 ratio) internal pure returns (uint256 c) {
        return mulTruncateScale(x, ratio, RATIO_SCALE);
    }

    /**
     * @dev Multiplies and truncates a token ratio, rounding up the result
     *      i.e. How much mAsset is this bAsset worth?
     * @param x     Left hand input to multiplication (i.e Exact quantity)
     * @param ratio bAsset ratio
     * @return      Result after multiplying the two inputs and then dividing by the shared
     *              ratio scale, rounded up to the closest base unit.
     */
    function mulRatioTruncateCeil(uint256 x, uint256 ratio) internal pure returns (uint256) {
        // e.g. How much mAsset should I burn for this bAsset (x)?
        // 1e18 * 1e8 = 1e26
        uint256 scaled = x * ratio;
        // 1e26 + 9.99e7 = 100..00.999e8
        uint256 ceil = scaled + RATIO_SCALE - 1;
        // return 100..00.999e8 / 1e8 = 1e18
        return ceil / RATIO_SCALE;
    }

    /**
     * @dev Precisely divides two ratioed units, by first scaling the left hand operand
     *      i.e. How much bAsset is this mAsset worth?
     * @param x     Left hand operand in division
     * @param ratio bAsset ratio
     * @return c    Result after multiplying the left operand by the scale, and
     *              executing the division on the right hand input.
     */
    function divRatioPrecisely(uint256 x, uint256 ratio) internal pure returns (uint256 c) {
        // e.g. 1e14 * 1e8 = 1e22
        // return 1e22 / 1e12 = 1e10
        return (x * RATIO_SCALE) / ratio;
    }

    /***************************************
                    HELPERS
    ****************************************/

    /**
     * @dev Calculates minimum of two numbers
     * @param x     Left hand input
     * @param y     Right hand input
     * @return      Minimum of the two inputs
     */
    function min(uint256 x, uint256 y) internal pure returns (uint256) {
        return x > y ? y : x;
    }

    /**
     * @dev Calculated maximum of two numbers
     * @param x     Left hand input
     * @param y     Right hand input
     * @return      Maximum of the two inputs
     */
    function max(uint256 x, uint256 y) internal pure returns (uint256) {
        return x > y ? x : y;
    }

    /**
     * @dev Clamps a value to an upper bound
     * @param x           Left hand input
     * @param upperBound  Maximum possible value to return
     * @return            Input x clamped to a maximum value, upperBound
     */
    function clamp(uint256 x, uint256 upperBound) internal pure returns (uint256) {
        return x > upperBound ? upperBound : x;
    }
}

library YieldValidator {
    uint256 private constant SECONDS_IN_YEAR = 365 days;
    uint256 private constant THIRTY_MINUTES = 30 minutes;

    uint256 private constant MAX_APY = 15e18;
    uint256 private constant TEN_BPS = 1e15;

    /**
     * @dev Validates that an interest collection does not exceed a maximum APY. If last collection
     * was under 30 mins ago, simply check it does not exceed 10bps
     * @param _newSupply               New total supply of the mAsset
     * @param _interest                Increase in total supply since last collection
     * @param _timeSinceLastCollection Seconds since last collection
     */
    function validateCollection(
        uint256 _newSupply,
        uint256 _interest,
        uint256 _timeSinceLastCollection
    ) internal pure returns (uint256 extrapolatedAPY) {
        return
            validateCollection(_newSupply, _interest, _timeSinceLastCollection, MAX_APY, TEN_BPS);
    }

    /**
     * @dev Validates that an interest collection does not exceed a maximum APY. If last collection
     * was under 30 mins ago, simply check it does not exceed 10bps
     * @param _newSupply               New total supply of the mAsset
     * @param _interest                Increase in total supply since last collection
     * @param _timeSinceLastCollection Seconds since last collection
     * @param _maxApy                  Max APY where 100% == 1e18
     * @param _baseApy                 If less than 30 mins, do not exceed this % increase
     */
    function validateCollection(
        uint256 _newSupply,
        uint256 _interest,
        uint256 _timeSinceLastCollection,
        uint256 _maxApy,
        uint256 _baseApy
    ) internal pure returns (uint256 extrapolatedAPY) {
        uint256 protectedTime = _timeSinceLastCollection == 0 ? 1 : _timeSinceLastCollection;

        // Percentage increase in total supply
        // e.g. (1e20 * 1e18) / 1e24 = 1e14 (or a 0.01% increase)
        // e.g. (5e18 * 1e18) / 1.2e24 = 4.1667e12
        // e.g. (1e19 * 1e18) / 1e21 = 1e16
        uint256 oldSupply = _newSupply - _interest;
        uint256 percentageIncrease = (_interest * 1e18) / oldSupply;

        //      If over 30 mins, extrapolate APY
        // e.g. day: (86400 * 1e18) / 3.154e7 = 2.74..e15
        // e.g. 30 mins: (1800 * 1e18) / 3.154e7 = 5.7..e13
        // e.g. epoch: (1593596907 * 1e18) / 3.154e7 = 50.4..e18
        uint256 yearsSinceLastCollection = (protectedTime * 1e18) / SECONDS_IN_YEAR;

        // e.g. 0.01% (1e14 * 1e18) / 2.74..e15 = 3.65e16 or 3.65% apr
        // e.g. (4.1667e12 * 1e18) / 5.7..e13 = 7.1e16 or 7.1% apr
        // e.g. (1e16 * 1e18) / 50e18 = 2e14
        extrapolatedAPY = (percentageIncrease * 1e18) / yearsSinceLastCollection;

        if (protectedTime > THIRTY_MINUTES) {
            require(extrapolatedAPY < _maxApy, "Interest protected from inflating past maxAPY");
        } else {
            require(percentageIncrease < _baseApy, "Interest protected from inflating past 10 Bps");
        }
    }
}

/**
 * @title   SavingsContract
 * @author voltfinance
 * @notice  Savings contract uses the ever increasing "exchangeRate" to increase
 *          the value of the Savers "credits" (ERC20) relative to the amount of additional
 *          underlying collateral that has been deposited into this contract ("interest")
 * @dev     VERSION: 2.2
 *          DATE:    2022-04-08
 */
contract SavingsContract_imusd_polygon_22 is
    ISavingsContractV4,
    Initializable,
    InitializableToken,
    ImmutableModule
{
    using StableMath for uint256;

    // Core events for depositing and withdrawing
    event ExchangeRateUpdated(uint256 newExchangeRate, uint256 interestCollected);
    event SavingsDeposited(address indexed saver, uint256 savingsDeposited, uint256 creditsIssued);
    event CreditsRedeemed(
        address indexed redeemer,
        uint256 creditsRedeemed,
        uint256 savingsCredited
    );

    event AutomaticInterestCollectionSwitched(bool automationEnabled);

    // Connector poking
    event PokerUpdated(address poker);

    event FractionUpdated(uint256 fraction);
    event ConnectorUpdated(address connector);
    event EmergencyUpdate();

    event Poked(uint256 oldBalance, uint256 newBalance, uint256 interestDetected);
    event PokedRaw();

    // Tracking events
    event Referral(address indexed referrer, address beneficiary, uint256 amount);

    // Rate between 'savings credits' and underlying
    // e.g. 1 credit (1e17) mulTruncate(exchangeRate) = underlying, starts at 10:1
    // exchangeRate increases over time
    uint256 private constant startingRate = 1e17;
    uint256 public override exchangeRate;

    // Underlying asset is underlying
    IERC20 public immutable underlying;
    bool private automateInterestCollection;

    // Yield
    // Poker is responsible for depositing/withdrawing from connector
    address public poker;
    // Last time a poke was made
    uint256 public lastPoke;
    // Last known balance of the connector
    uint256 public lastBalance;
    // Fraction of capital assigned to the connector (100% = 1e18)
    uint256 public fraction;
    // Address of the current connector (all IConnectors are mStable validated)
    IConnector public connector;
    // How often do we allow pokes
    uint256 private constant POKE_CADENCE = 4 hours;
    // Max APY generated on the capital in the connector
    uint256 private constant MAX_APY = 4e18;
    uint256 private constant SECONDS_IN_YEAR = 365 days;
    // Proxy contract for easy redemption
    address public immutable unwrapper;

    constructor(
        address _nexus,
        address _underlying,
        address _unwrapper
    ) ImmutableModule(_nexus) {
        require(_underlying != address(0), "mAsset address is zero");
        require(_unwrapper != address(0), "Unwrapper address is zero");
        underlying = IERC20(_underlying);
        unwrapper = _unwrapper;
    }

    // Add these constants to bytecode at deploytime
    function initialize(
        address _poker,
        string calldata _nameArg,
        string calldata _symbolArg
    ) external initializer {
        InitializableToken._initialize(_nameArg, _symbolArg);

        require(_poker != address(0), "Invalid poker address");
        poker = _poker;

        fraction = 2e17;
        automateInterestCollection = true;
        exchangeRate = startingRate;
    }

    /** @dev Only the savings managaer (pulled from Nexus) can execute this */
    modifier onlySavingsManager() {
        require(msg.sender == _savingsManager(), "Only savings manager can execute");
        _;
    }

    /***************************************
                    VIEW - E
    ****************************************/

    /**
     * @dev Returns the underlying balance of a given user
     * @param _user     Address of the user to check
     * @return balance  Units of underlying owned by the user
     */
    function balanceOfUnderlying(address _user) external view override returns (uint256 balance) {
        (balance, ) = _creditsToUnderlying(balanceOf(_user));
    }

    /**
     * @dev Converts a given underlying amount into credits
     * @param _underlying  Units of underlying
     * @return credits     Credit units (a.k.a imUSD)
     */
    function underlyingToCredits(uint256 _underlying)
        external
        view
        override
        returns (uint256 credits)
    {
        (credits, ) = _underlyingToCredits(_underlying);
    }

    /**
     * @dev Converts a given credit amount into underlying
     * @param _credits  Units of credits
     * @return amount   Corresponding underlying amount
     */
    function creditsToUnderlying(uint256 _credits) external view override returns (uint256 amount) {
        (amount, ) = _creditsToUnderlying(_credits);
    }

    // Deprecated in favour of `balanceOf(address)`
    // Maintained for backwards compatibility
    // Returns the credit balance of a given user
    function creditBalances(address _user) external view override returns (uint256) {
        return balanceOf(_user);
    }

    /***************************************
                    INTEREST
    ****************************************/

    /**
     * @dev Deposit interest (add to savings) and update exchange rate of contract.
     *      Exchange rate is calculated as the ratio between new savings q and credits:
     *                    exchange rate = savings / credits
     *
     * @param _amount   Units of underlying to add to the savings vault
     */
    function depositInterest(uint256 _amount) external override onlySavingsManager {
        require(_amount > 0, "Must deposit something");

        // Transfer the interest from sender to here
        require(underlying.transferFrom(msg.sender, address(this), _amount), "Must receive tokens");

        // Calc new exchange rate, protect against initialisation case
        uint256 totalCredits = totalSupply();
        if (totalCredits > 0) {
            // new exchange rate is relationship between _totalCredits & totalSavings
            // _totalCredits * exchangeRate = totalSavings
            // exchangeRate = totalSavings/_totalCredits
            (uint256 totalCollat, ) = _creditsToUnderlying(totalCredits);
            uint256 newExchangeRate = _calcExchangeRate(totalCollat + _amount, totalCredits);
            exchangeRate = newExchangeRate;

            emit ExchangeRateUpdated(newExchangeRate, _amount);
        }
    }

    /** @dev Enable or disable the automation of fee collection during deposit process */
    function automateInterestCollectionFlag(bool _enabled) external onlyGovernor {
        automateInterestCollection = _enabled;
        emit AutomaticInterestCollectionSwitched(_enabled);
    }

    /***************************************
                    DEPOSIT
    ****************************************/

    /**
     * @dev During a migration period, allow savers to deposit underlying here before the interest has been redirected
     * @param _underlying      Units of underlying to deposit into savings vault
     * @param _beneficiary     Immediately transfer the imUSD token to this beneficiary address
     * @return creditsIssued   Units of credits (imUSD) issued
     */
    function preDeposit(uint256 _underlying, address _beneficiary)
        external
        returns (uint256 creditsIssued)
    {
        require(exchangeRate == startingRate, "Can only use this method before streaming begins");
        return _deposit(_underlying, _beneficiary, false);
    }

    /**
     * @dev Deposit the senders savings to the vault, and credit them internally with "credits".
     *      Credit amount is calculated as a ratio of deposit amount and exchange rate:
     *                    credits = underlying / exchangeRate
     *      We will first update the internal exchange rate by collecting any interest generated on the underlying.
     * @param _underlying      Units of underlying to deposit into savings vault
     * @return creditsIssued   Units of credits (imUSD) issued
     */
    function depositSavings(uint256 _underlying) external override returns (uint256 creditsIssued) {
        return _deposit(_underlying, msg.sender, true);
    }

    /**
     * @dev Deposit the senders savings to the vault, and credit them internally with "credits".
     *      Credit amount is calculated as a ratio of deposit amount and exchange rate:
     *                    credits = underlying / exchangeRate
     *      We will first update the internal exchange rate by collecting any interest generated on the underlying.
     * @param _underlying      Units of underlying to deposit into savings vault
     * @param _beneficiary     Immediately transfer the imUSD token to this beneficiary address
     * @return creditsIssued   Units of credits (imUSD) issued
     */
    function depositSavings(uint256 _underlying, address _beneficiary)
        external
        override
        returns (uint256 creditsIssued)
    {
        return _deposit(_underlying, _beneficiary, true);
    }

    /**
     * @dev Overloaded `depositSavings` method with an optional referrer address.
     * @param _underlying      Units of underlying to deposit into savings vault
     * @param _beneficiary     Immediately transfer the imUSD token to this beneficiary address
     * @param _referrer        Referrer address for this deposit
     * @return creditsIssued   Units of credits (imUSD) issued
     */
    function depositSavings(
        uint256 _underlying,
        address _beneficiary,
        address _referrer
    ) external override returns (uint256 creditsIssued) {
        emit Referral(_referrer, _beneficiary, _underlying);
        return _deposit(_underlying, _beneficiary, true);
    }

    /**
     * @dev Internally deposit the _underlying from the sender and credit the beneficiary with new imUSD
     */
    function _deposit(
        uint256 _underlying,
        address _beneficiary,
        bool _collectInterest
    ) internal returns (uint256 creditsIssued) {
        creditsIssued = _transferAndMint(_underlying, _beneficiary, _collectInterest);
    }

    /***************************************
                    REDEEM
    ****************************************/

    // Deprecated in favour of redeemCredits
    // Maintaining backwards compatibility, this fn minimics the old redeem fn, in which
    // credits are redeemed but the interest from the underlying is not collected.
    function redeem(uint256 _credits) external override returns (uint256 massetReturned) {
        require(_credits > 0, "Must withdraw something");

        (, uint256 payout) = _redeem(_credits, true, true);

        // Collect recent interest generated by basket and update exchange rate
        if (automateInterestCollection) {
            ISavingsManager(_savingsManager()).collectAndDistributeInterest(address(underlying));
        }

        return payout;
    }

    /**
     * @dev Redeem specific number of the senders "credits" in exchange for underlying.
     *      Payout amount is calculated as a ratio of credits and exchange rate:
     *                    payout = credits * exchangeRate
     * @param _credits         Amount of credits to redeem
     * @return massetReturned  Units of underlying mAsset paid out
     */
    function redeemCredits(uint256 _credits) external override returns (uint256 massetReturned) {
        require(_credits > 0, "Must withdraw something");

        // Collect recent interest generated by basket and update exchange rate
        if (automateInterestCollection) {
            ISavingsManager(_savingsManager()).collectAndDistributeInterest(address(underlying));
        }

        (, uint256 payout) = _redeem(_credits, true, true);

        return payout;
    }

    /**
     * @dev Redeem credits into a specific amount of underlying.
     *      Credits needed to burn is calculated using:
     *                    credits = underlying / exchangeRate
     * @param _underlying     Amount of underlying to redeem
     * @return creditsBurned  Units of credits burned from sender
     */
    function redeemUnderlying(uint256 _underlying)
        external
        override
        returns (uint256 creditsBurned)
    {
        require(_underlying > 0, "Must withdraw something");

        // Collect recent interest generated by basket and update exchange rate
        if (automateInterestCollection) {
            ISavingsManager(_savingsManager()).collectAndDistributeInterest(address(underlying));
        }

        // Ensure that the payout was sufficient
        (uint256 credits, uint256 massetReturned) = _redeem(_underlying, false, true);
        require(massetReturned == _underlying, "Invalid output");

        return credits;
    }

    /**
     * @notice Redeem credits into a specific amount of underlying, unwrap
     *      into a selected output asset, and send to a beneficiary
     *      Credits needed to burn is calculated using:
     *                    credits = underlying / exchangeRate
     * @param _amount         Units to redeem (either underlying or credit amount).
     * @param _isCreditAmt    `true` if `amount` is in credits. eg imUSD. `false` if `amount` is in underlying. eg mUSD.
     * @param _minAmountOut   Minimum amount of `output` tokens to unwrap for. This is to the same decimal places as the `output` token.
     * @param _output         Asset to receive in exchange for the redeemed mAssets. This can be a bAsset or a fAsset. For example:
        - bAssets (USDC, DAI, sUSD or USDT) or fAssets (GUSD, BUSD, alUSD, FEI or RAI) for mainnet imUSD Vault.
        - bAssets (USDC, DAI or USDT) or fAsset FRAX for Polygon imUSD Vault.
        - bAssets (WBTC, sBTC or renBTC) or fAssets (HBTC or TBTCV2) for mainnet imBTC Vault.
     * @param _beneficiary    Address to send `output` tokens to.
     * @param _router         mAsset address if the output is a bAsset. Feeder Pool address if the output is a fAsset.
     * @param _isBassetOut    `true` if `output` is a bAsset. `false` if `output` is a fAsset.
     * @return creditsBurned  Units of credits burned from sender. eg imUSD or imBTC.
     * @return massetReturned Units of the underlying mAssets that were redeemed or swapped for the output tokens. eg mUSD or mBTC.
     * @return outputQuantity Units of `output` tokens sent to the beneficiary.
     */
    function redeemAndUnwrap(
        uint256 _amount,
        bool _isCreditAmt,
        uint256 _minAmountOut,
        address _output,
        address _beneficiary,
        address _router,
        bool _isBassetOut
    )
        external
        override
        returns (
            uint256 creditsBurned,
            uint256 massetReturned,
            uint256 outputQuantity
        )
    {
        require(_amount > 0, "Must withdraw something");
        require(_output != address(0), "Output address is zero");
        require(_beneficiary != address(0), "Beneficiary address is zero");
        require(_router != address(0), "Router address is zero");

        // Collect recent interest generated by basket and update exchange rate
        if (automateInterestCollection) {
            ISavingsManager(_savingsManager()).collectAndDistributeInterest(address(underlying));
        }

        // Ensure that the payout was sufficient
        (creditsBurned, massetReturned) = _redeem(_amount, _isCreditAmt, false);
        require(
            _isCreditAmt ? creditsBurned == _amount : massetReturned == _amount,
            "Invalid output"
        );

        // Approve wrapper to spend contract's underlying; just for this tx
        underlying.approve(unwrapper, massetReturned);

        // Unwrap the underlying into `output` and transfer to `beneficiary`
        outputQuantity = IUnwrapper(unwrapper).unwrapAndSend(
            _isBassetOut,
            _router,
            address(underlying),
            _output,
            massetReturned,
            _minAmountOut,
            _beneficiary
        );
    }

    /**
     * @dev Internally burn the credits and send the underlying to msg.sender
     */
    function _redeem(
        uint256 _amt,
        bool _isCreditAmt,
        bool _transferUnderlying
    ) internal returns (uint256 creditsBurned, uint256 massetReturned) {
        // Centralise credit <> underlying calcs and minimise SLOAD count
        uint256 credits_;
        uint256 underlying_;
        uint256 exchangeRate_;
        // If the input is a credit amt, then calculate underlying payout and cache the exchangeRate
        if (_isCreditAmt) {
            credits_ = _amt;
            (underlying_, exchangeRate_) = _creditsToUnderlying(_amt);
        }
        // If the input is in underlying, then calculate credits needed to burn
        else {
            underlying_ = _amt;
            (credits_, exchangeRate_) = _underlyingToCredits(_amt);
        }

        _burnTransfer(
            underlying_,
            credits_,
            msg.sender,
            msg.sender,
            exchangeRate_,
            _transferUnderlying
        );

        emit CreditsRedeemed(msg.sender, credits_, underlying_);

        return (credits_, underlying_);
    }

    struct ConnectorStatus {
        // Limit is the max amount of units allowed in the connector
        uint256 limit;
        // Derived balance of the connector
        uint256 inConnector;
    }

    /**
     * @dev Derives the units of collateral held in the connector
     * @param _data         Struct containing data on balances
     * @param _exchangeRate Current system exchange rate
     * @return status       Contains max amount of assets allowed in connector
     */
    function _getConnectorStatus(CachedData memory _data, uint256 _exchangeRate)
        internal
        pure
        returns (ConnectorStatus memory)
    {
        // Total units of underlying collateralised
        uint256 totalCollat = _data.totalCredits.mulTruncate(_exchangeRate);
        // Max amount of underlying that can be held in the connector
        uint256 limit = totalCollat.mulTruncate(_data.fraction + 2e17);
        // Derives amount of underlying present in the connector
        uint256 inConnector = _data.rawBalance >= totalCollat ? 0 : totalCollat - _data.rawBalance;

        return ConnectorStatus(limit, inConnector);
    }

    /***************************************
                    YIELD - E
    ****************************************/

    /** @dev Modifier allowing only the designated poker to execute the fn */
    modifier onlyPoker() {
        require(msg.sender == poker, "Only poker can execute");
        _;
    }

    /**
     * @dev External poke function allows for the redistribution of collateral between here and the
     * current connector, setting the ratio back to the defined optimal.
     */
    function poke() external onlyPoker {
        CachedData memory cachedData = _cacheData();
        _poke(cachedData, false);
    }

    /**
     * @dev Governance action to set the address of a new poker
     * @param _newPoker     Address of the new poker
     */
    function setPoker(address _newPoker) external onlyGovernor {
        require(_newPoker != address(0) && _newPoker != poker, "Invalid poker");

        poker = _newPoker;

        emit PokerUpdated(_newPoker);
    }

    /**
     * @dev Governance action to set the percentage of assets that should be held
     * in the connector.
     * @param _fraction     Percentage of assets that should be held there (where 20% == 2e17)
     */
    function setFraction(uint256 _fraction) external onlyGovernor {
        require(_fraction <= 5e17, "Fraction must be <= 50%");

        fraction = _fraction;

        CachedData memory cachedData = _cacheData();
        _poke(cachedData, true);

        emit FractionUpdated(_fraction);
    }

    /**
     * @dev Governance action to set the address of a new connector, and move funds (if any) across.
     * @param _newConnector     Address of the new connector
     */
    function setConnector(address _newConnector) external onlyGovernor {
        // Withdraw all from previous by setting target = 0
        CachedData memory cachedData = _cacheData();
        cachedData.fraction = 0;
        _poke(cachedData, true);

        // Set new connector
        CachedData memory cachedDataNew = _cacheData();
        connector = IConnector(_newConnector);
        _poke(cachedDataNew, true);

        emit ConnectorUpdated(_newConnector);
    }

    /**
     * @dev Governance action to perform an emergency withdraw of the assets in the connector,
     * should it be the case that some or all of the liquidity is trapped in. This causes the total
     * collateral in the system to go down, causing a hard refresh.
     */
    function emergencyWithdraw(uint256 _withdrawAmount) external onlyGovernor {
        // withdraw _withdrawAmount from connection
        connector.withdraw(_withdrawAmount);

        // reset the connector
        connector = IConnector(address(0));
        emit ConnectorUpdated(address(0));

        // set fraction to 0
        fraction = 0;
        emit FractionUpdated(0);

        // check total collateralisation of credits
        CachedData memory data = _cacheData();
        // use rawBalance as the remaining liquidity in the connector is now written off
        _refreshExchangeRate(data.rawBalance, data.totalCredits, true);

        emit EmergencyUpdate();
    }

    /***************************************
                    YIELD - I
    ****************************************/

    /** @dev Internal poke function to keep the balance between connector and raw balance healthy */
    function _poke(CachedData memory _data, bool _ignoreCadence) internal {
        require(_data.totalCredits > 0, "Must have something to poke");

        // 1. Verify that poke cadence is valid, unless this is a manual action by governance
        uint256 currentTime = uint256(block.timestamp);
        uint256 timeSinceLastPoke = currentTime - lastPoke;
        require(_ignoreCadence || timeSinceLastPoke > POKE_CADENCE, "Not enough time elapsed");
        lastPoke = currentTime;

        // If there is a connector, check the balance and settle to the specified fraction %
        IConnector connector_ = connector;
        if (address(connector_) != address(0)) {
            // 2. Check and verify new connector balance
            uint256 lastBalance_ = lastBalance;
            uint256 connectorBalance = connector_.checkBalance();
            //      Always expect the collateral in the connector to increase in value
            require(connectorBalance >= lastBalance_, "Invalid yield");
            if (connectorBalance > 0) {
                //  Validate the collection by ensuring that the APY is not ridiculous
                YieldValidator.validateCollection(
                    connectorBalance,
                    connectorBalance - lastBalance_,
                    timeSinceLastPoke,
                    MAX_APY,
                    1e15
                );
            }

            // 3. Level the assets to Fraction (connector) & 100-fraction (raw)
            uint256 sum = _data.rawBalance + connectorBalance;
            uint256 ideal = sum.mulTruncate(_data.fraction);
            //     If there is not enough mAsset in the connector, then deposit
            if (ideal > connectorBalance) {
                uint256 deposit_ = ideal - connectorBalance;
                underlying.approve(address(connector_), deposit_);
                connector_.deposit(deposit_);
            }
            //     Else withdraw, if there is too much mAsset in the connector
            else if (connectorBalance > ideal) {
                // If fraction == 0, then withdraw everything
                if (ideal == 0) {
                    connector_.withdrawAll();
                    sum = IERC20(underlying).balanceOf(address(this));
                } else {
                    connector_.withdraw(connectorBalance - ideal);
                }
            }
            //     Else ideal == connectorBalance (e.g. 0), do nothing
            require(connector_.checkBalance() >= ideal, "Enforce system invariant");

            // 4i. Refresh exchange rate and emit event
            lastBalance = ideal;
            _refreshExchangeRate(sum, _data.totalCredits, false);
            emit Poked(lastBalance_, ideal, connectorBalance - lastBalance_);
        } else {
            // 4ii. Refresh exchange rate and emit event
            lastBalance = 0;
            _refreshExchangeRate(_data.rawBalance, _data.totalCredits, false);
            emit PokedRaw();
        }
    }

    /**
     * @dev Internal fn to refresh the exchange rate, based on the sum of collateral and the number of credits
     * @param _realSum          Sum of collateral held by the contract
     * @param _totalCredits     Total number of credits in the system
     * @param _ignoreValidation This is for use in the emergency situation, and ignores a decreasing exchangeRate
     */
    function _refreshExchangeRate(
        uint256 _realSum,
        uint256 _totalCredits,
        bool _ignoreValidation
    ) internal {
        // Based on the current exchange rate, how much underlying is collateralised?
        (uint256 totalCredited, ) = _creditsToUnderlying(_totalCredits);

        // Require the amount of capital held to be greater than the previously credited units
        require(_ignoreValidation || _realSum >= totalCredited, "ExchangeRate must increase");
        // Work out the new exchange rate based on the current capital
        uint256 newExchangeRate = _calcExchangeRate(_realSum, _totalCredits);
        exchangeRate = newExchangeRate;

        emit ExchangeRateUpdated(
            newExchangeRate,
            _realSum > totalCredited ? _realSum - totalCredited : 0
        );
    }

    /***************************************
                    VIEW - I
    ****************************************/

    struct CachedData {
        // SLOAD from 'fraction'
        uint256 fraction;
        // ERC20 balance of underlying, held by this contract
        // underlying.balanceOf(address(this))
        uint256 rawBalance;
        // totalSupply()
        uint256 totalCredits;
    }

    /**
     * @dev Retrieves generic data to avoid duplicate SLOADs
     */
    function _cacheData() internal view returns (CachedData memory) {
        uint256 balance = underlying.balanceOf(address(this));
        return CachedData(fraction, balance, totalSupply());
    }

    /**
     * @dev Converts masset amount into credits based on exchange rate
     *               c = (masset / exchangeRate) + 1
     */
    function _underlyingToCredits(uint256 _underlying)
        internal
        view
        returns (uint256 credits, uint256 exchangeRate_)
    {
        // e.g. (1e20 * 1e18) / 1e18 = 1e20
        // e.g. (1e20 * 1e18) / 14e17 = 7.1429e19
        // e.g. 1 * 1e18 / 1e17 + 1 = 11 => 11 * 1e17 / 1e18 = 1.1e18 / 1e18 = 1
        exchangeRate_ = exchangeRate;
        credits = _underlying.divPrecisely(exchangeRate_) + 1;
    }

    /**
     * @dev Works out a new exchange rate, given an amount of collateral and total credits
     *               e = underlying / (credits-1)
     */
    function _calcExchangeRate(uint256 _totalCollateral, uint256 _totalCredits)
        internal
        pure
        returns (uint256 _exchangeRate)
    {
        _exchangeRate = _totalCollateral.divPrecisely(_totalCredits - 1);
    }

    /**
     * @dev Converts credit amount into masset based on exchange rate
     *               m = credits * exchangeRate
     */
    function _creditsToUnderlying(uint256 _credits)
        internal
        view
        returns (uint256 underlyingAmount, uint256 exchangeRate_)
    {
        // e.g. (1e20 * 1e18) / 1e18 = 1e20
        // e.g. (1e20 * 14e17) / 1e18 = 1.4e20
        exchangeRate_ = exchangeRate;
        underlyingAmount = _credits.mulTruncate(exchangeRate_);
    }

    /*///////////////////////////////////////////////////////////////
                                IERC4626Vault
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice it must be an ERC-20 token contract. Must not revert.
     *
     * @return assetTokenAddress the address of the underlying asset token. eg mUSD or mBTC
     */
    function asset() external view override returns (address assetTokenAddress) {
        return address(underlying);
    }

    /**
     * @return totalManagedAssets the total amount of the underlying asset tokens that is “managed” by Vault.
     */
    function totalAssets() external view override returns (uint256 totalManagedAssets) {
        return underlying.balanceOf(address(this));
    }

    /**
     * @notice The amount of shares that the Vault would exchange for the amount of assets provided, in an ideal scenario where all the conditions are met.
     * @param assets The amount of underlying assets to be convert to vault shares.
     * @return shares The amount of vault shares converted from the underlying assets.
     */
    function convertToShares(uint256 assets) external view override returns (uint256 shares) {
        (shares, ) = _underlyingToCredits(assets);
    }

    /**
     * @notice The amount of assets that the Vault would exchange for the amount of shares provided, in an ideal scenario where all the conditions are met.
     * @param shares The amount of vault shares to be converted to the underlying assets.
     * @return assets The amount of underlying assets converted from the vault shares.
     */
    function convertToAssets(uint256 shares) external view override returns (uint256 assets) {
        (assets, ) = _creditsToUnderlying(shares);
    }

    /**
     * @notice The maximum number of underlying assets that caller can deposit.
     * caller Account that the assets will be transferred from.
     * @return maxAssets The maximum amount of underlying assets the caller can deposit.
     */
    function maxDeposit(
        address /** caller **/
    ) external pure override returns (uint256 maxAssets) {
        maxAssets = type(uint256).max;
    }

    /**
     * @notice Allows an on-chain or off-chain user to simulate the effects of their deposit at the current block, given current on-chain conditions.
     * @param assets The amount of underlying assets to be transferred.
     * @return shares The amount of vault shares that will be minted.
     */
    function previewDeposit(uint256 assets) external view override returns (uint256 shares) {
        require(assets > 0, "Must deposit something");
        (shares, ) = _underlyingToCredits(assets);
    }

    /**
     * @notice Mint vault shares to receiver by transferring exact amount of underlying asset tokens from the caller.
     *      Credit amount is calculated as a ratio of deposit amount and exchange rate:
     *                    credits = underlying / exchangeRate
     *      We will first update the internal exchange rate by collecting any interest generated on the underlying.
     * Emits a {Deposit} event.
     * @param assets      Units of underlying to deposit into savings vault. eg mUSD or mBTC
     * @param receiver    The address to receive the Vault shares.
     * @return shares     Units of credits issued. eg imUSD or imBTC
     */
    function deposit(uint256 assets, address receiver) external override returns (uint256 shares) {
        shares = _transferAndMint(assets, receiver, true);
    }

    /**
     *
     * @notice Overloaded `deposit` method with an optional referrer address.
     * @param assets    Units of underlying to deposit into savings vault. eg mUSD or mBTC
     * @param receiver  Address to the new credits will be issued to.
     * @param referrer  Referrer address for this deposit.
     * @return shares   Units of credits issued. eg imUSD or imBTC
     */
    function deposit(
        uint256 assets,
        address receiver,
        address referrer
    ) external override returns (uint256 shares) {
        shares = _transferAndMint(assets, receiver, true);
        emit Referral(referrer, receiver, assets);
    }

    /**
     * @notice The maximum number of vault shares that caller can mint.
     * caller Account that the underlying assets will be transferred from.
     * @return maxShares The maximum amount of vault shares the caller can mint.
     */
    function maxMint(
        address /* caller */
    ) external pure override returns (uint256 maxShares) {
        maxShares = type(uint256).max;
    }

    /**
     * @notice Allows an on-chain or off-chain user to simulate the effects of their mint at the current block, given current on-chain conditions.
     * @param shares The amount of vault shares to be minted.
     * @return assets The amount of underlying assests that will be transferred from the caller.
     */
    function previewMint(uint256 shares) external view override returns (uint256 assets) {
        (assets, ) = _creditsToUnderlying(shares);
        return assets;
    }

    /**
     * @notice Mint exact amount of vault shares to the receiver by transferring enough underlying asset tokens from the caller.
     * Emits a {Deposit} event.
     *
     * @param shares The amount of vault shares to be minted.
     * @param receiver The account the vault shares will be minted to.
     * @return assets The amount of underlying assets that were transferred from the caller.
     */
    function mint(uint256 shares, address receiver) external override returns (uint256 assets) {
        (assets, ) = _creditsToUnderlying(shares);
        _transferAndMint(assets, receiver, true);
    }

    /**
     * @notice Mint exact amount of vault shares to the receiver by transferring enough underlying asset tokens from the caller.
     * @param shares The amount of vault shares to be minted.
     * @param receiver The account the vault shares will be minted to.
     * @param referrer  Referrer address for this deposit.
     * @return assets The amount of underlying assets that were transferred from the caller.
     * Emits a {Deposit}, {Referral} events
     */
    function mint(
        uint256 shares,
        address receiver,
        address referrer
    ) external override returns (uint256 assets) {
        (assets, ) = _creditsToUnderlying(shares);
        _transferAndMint(assets, receiver, true);
        emit Referral(referrer, receiver, assets);
    }

    /**
     * @notice The maximum number of underlying assets that owner can withdraw.
     * @param owner Address that owns the underlying assets.
     * @return maxAssets The maximum amount of underlying assets the owner can withdraw.
     */
    function maxWithdraw(address owner) external view override returns (uint256 maxAssets) {
        (maxAssets, ) = _creditsToUnderlying(balanceOf(owner));
    }

    /**
     * @notice Allows an on-chain or off-chain user to simulate the effects of their withdrawal at the current block, given current on-chain conditions.
     * @param assets The amount of underlying assets to be withdrawn.
     * @return shares The amount of vault shares that will be burnt.
     */
    function previewWithdraw(uint256 assets) external view override returns (uint256 shares) {
        (shares, ) = _underlyingToCredits(assets);
    }

    /**
     * @notice Burns enough vault shares from owner and transfers the exact amount of underlying asset tokens to the receiver.
     * Emits a {Withdraw} event.
     *
     * @param assets The amount of underlying assets to be withdrawn from the vault.
     * @param receiver The account that the underlying assets will be transferred to.
     * @param owner Account that owns the vault shares to be burnt.
     * @return shares The amount of vault shares that were burnt.
     */
    function withdraw(
        uint256 assets,
        address receiver,
        address owner
    ) external override returns (uint256 shares) {
        require(assets > 0, "Must withdraw something");
        uint256 _exchangeRate;
        if (automateInterestCollection) {
            ISavingsManager(_savingsManager()).collectAndDistributeInterest(address(underlying));
        }
        (shares, _exchangeRate) = _underlyingToCredits(assets);

        _burnTransfer(assets, shares, receiver, owner, _exchangeRate, true);
    }

    /**
     * @notice it must return a limited value if owner is subject to some withdrawal limit or timelock. must return balanceOf(owner) if owner is not subject to any withdrawal limit or timelock. MAY be used in the previewRedeem or redeem methods for shares input parameter. must NOT revert.
     *
     * @param owner Address that owns the shares.
     * @return maxShares Total number of shares that owner can redeem.
     */
    function maxRedeem(address owner) external view override returns (uint256 maxShares) {
        maxShares = balanceOf(owner);
    }

    /**
     * @notice Allows an on-chain or off-chain user to simulate the effects of their redeemption at the current block, given current on-chain conditions.
     *
     * @return assets the exact amount of underlying assets that would be withdrawn by the caller if redeeming a given exact amount of Vault shares using the redeem method
     */
    function previewRedeem(uint256 shares) external view override returns (uint256 assets) {
        (assets, ) = _creditsToUnderlying(shares);
        return assets;
    }

    /**
     * @notice Burns exact amount of vault shares from owner and transfers the underlying asset tokens to the receiver.
     * Emits a {Withdraw} event.
     *
     * @param shares The amount of vault shares to be burnt.
     * @param receiver The account the underlying assets will be transferred to.
     * @param owner The account that owns the vault shares to be burnt.
     * @return assets The amount of underlying assets that were transferred to the receiver.
     */
    function redeem(
        uint256 shares,
        address receiver,
        address owner
    ) external override returns (uint256 assets) {
        require(shares > 0, "Must withdraw something");
        uint256 _exchangeRate;
        if (automateInterestCollection) {
            ISavingsManager(_savingsManager()).collectAndDistributeInterest(address(underlying));
        }
        (assets, _exchangeRate) = _creditsToUnderlying(shares);

        _burnTransfer(assets, shares, receiver, owner, _exchangeRate, true); //transferAssets=true
    }

    /*///////////////////////////////////////////////////////////////
                        INTERNAL DEPOSIT/MINT
    //////////////////////////////////////////////////////////////*/
    function _transferAndMint(
        uint256 assets,
        address receiver,
        bool _collectInterest
    ) internal returns (uint256 shares) {
        require(assets > 0, "Must deposit something");
        require(receiver != address(0), "Invalid beneficiary address");

        // Collect recent interest generated by basket and update exchange rate
        IERC20 mAsset = underlying;
        if (_collectInterest) {
            ISavingsManager(_savingsManager()).collectAndDistributeInterest(address(mAsset));
        }

        // Transfer tokens from sender to here
        require(mAsset.transferFrom(msg.sender, address(this), assets), "Must receive tokens");

        // Calc how many credits they receive based on currentRatio
        (shares, ) = _underlyingToCredits(assets);

        // add credits to ERC20 balances
        _mint(receiver, shares);
        emit Deposit(msg.sender, receiver, assets, shares);
        emit SavingsDeposited(receiver, assets, shares);
    }

    /*///////////////////////////////////////////////////////////////
                        INTERNAL WITHDRAW/REDEEM
    //////////////////////////////////////////////////////////////*/

    function _burnTransfer(
        uint256 assets,
        uint256 shares,
        address receiver,
        address owner,
        uint256 _exchangeRate,
        bool transferAssets
    ) internal {
        require(receiver != address(0), "Invalid beneficiary address");

        // If caller is not the owner of the shares
        uint256 allowed = allowance(owner, msg.sender);
        if (msg.sender != owner && allowed != type(uint256).max) {
            require(shares <= allowed, "Amount exceeds allowance");
            _approve(owner, msg.sender, allowed - shares);
        }

        // Burn required shares from the owner FIRST
        _burn(owner, shares);

        // Optionally, transfer tokens from here to receiver
        if (transferAssets) {
            require(underlying.transfer(receiver, assets), "Must send tokens");
            emit Withdraw(msg.sender, receiver, owner, assets, shares);
        }
        // If this withdrawal pushes the portion of stored collateral in the `connector` over a certain
        // threshold (fraction + 20%), then this should trigger a _poke on the connector. This is to avoid
        // a situation in which there is a rush on withdrawals for some reason, causing the connector
        // balance to go up and thus having too large an exposure.
        CachedData memory cachedData = _cacheData();
        ConnectorStatus memory status = _getConnectorStatus(cachedData, _exchangeRate);
        if (status.inConnector > status.limit) {
            _poke(cachedData, false);
        }
    }
}
