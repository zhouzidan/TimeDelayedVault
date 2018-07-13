# TimeDelayedVault
# 合约地址
0x997f5d2A4865D48873E4D4130A791C801D209E12

## 关于重生
有一个12小时的限制。
刚刚智才同学已经更新过了，下次更新，需要发生在2018/7/14 15:55之前


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


先自行在测试网络上部署，在自己的测试网络上尝试
1. 先建立投票选出取钱的地址，每个小组成员都调用该函数
addAuthorizedAccount
投票选择取钱的目标是攻击合约的地址
2. 调用setObserver函数，随便一个地址
3. re-entry攻击

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
