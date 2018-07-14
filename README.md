# TimeDelayedVault
# 合约地址
0x997f5d2A4865D48873E4D4130A791C801D209E12

# `CommonWalletLibrary`合约地址
`0xaBCEAf05468b98518EE35Ab92cBE7a402A5F61f7`

# 攻击方案
## re-entry
    function withdrawFund() onlyAuthorized external returns (bool) {
        require(now > nextWithdrawTime);
        assert(withdrawObserver.call(bytes4(sha3("observe()"))));
        walletLibrary.delegatecall(bytes4(sha3("basicWithdraw()")));
        nextWithdrawTime = nextWithdrawTime + withdrawCoolDownTime;
        return true;
    }
因为这里的金额转账发生在时间修改之前。
根据第七课特别提到的re-entry攻击。通过智能合约去调用该方法，然后获得所有权之后，重复调用。在block gas limit限制下，尽量多的获取ETH。

尚未成功。

### 攻击流程
1. 需要确定每个人的地址在`authorizedUsers[index]`中的`index`；
2. 每个人调用`function addAuthorizedAccount(uint votePosition, address proposal)`，投票出攻击发动者
    - `votePosition`表示步骤1中的`index`
    - `proposal`表示推举出的攻击发动者地址
    - 此过程一旦有人输入错误的`proposal`地址，则需要全部重来
3. 攻击发动者调用`function setObserver(address ob)`，以避免`assert(withdrawObserver.call(bytes4(sha3("observe()"))))`验证失败
    - `ob`可为任意地址
4. 发动攻击



## 下一个方案
