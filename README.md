# TimeDelayedVault合约地址
0x997f5d2A4865D48873E4D4130A791C801D209E12
# CommonWalletLibrary钱包合约的地址
0xaBCEAf05468b98518EE35Ab92cBE7a402A5F61f7
# GamerVerifier的合约地址
0xf4b15e09b284ebeefdcbe0805376c309710fae6e


## 关于重生
有一个12小时的限制。
已经更新了，目前是2018/7/14 23:25:12

## 关于owner变量
1. TimeDelayedVault合约的owner被对手攻击了，对手是：0x158e66d874189b96f542e84f133e3de78f5c8602
[对应的TX](https://ropsten.etherscan.io/tx/0x53f3b87a74fdb37b1c610dc7216db5f0aae81af670c75abc2ebd34e99cd3de15)
2. CommonWalletLibrary合约的owner在我这边

> 风险：TimeDelayedVault .resolve()   
> 具备owner权限的人，可以销毁我们的合约。我们目前做的防护是更新时间，使其一直不满足12小时即可。  

# 取钱方案
## re-entry
> 这个方案基本是被放弃的。因为取钱太慢了。  
> 每次只能取几个0.01，每30min只能取一次。太慢了。  
### 攻击流程
1. 需要确定每个人的地址在`authorizedUsers[index]`中的`index`；
2. 每个人调用`function addAuthorizedAccount(uint votePosition, address proposal)`，投票出攻击发动者
		- `votePosition`表示步骤1中的`index`
		- `proposal`表示推举出的攻击发动者地址
		- 此过程一旦有人输入错误的`proposal`地址，则需要全部重来
3. 攻击发动者调用`function setObserver(address ob)`，以避免`assert(withdrawObserver.call(bytes4(sha3("observe()"))))`验证失败
		- `ob`可为任意地址
4. 发动攻击

## 下一个取钱方案
未定。
目前我觉得研究的方向，应该是在下面几个地方：
```
function setObserver(address ob)
withdrawObserver
observerHistory
```
因为到目前为止，还没看明白上面的函数和变量起到什么作用。
觉得是一个正确的方向。

## 关于取钱的目标合约
1. TimeDelayedVault合约
2. CommonWalletLibrary合约

**目标是1，TimeDelayedVault合约**
 
## 关于充值的方式
1. [不允许]  直接向合约的地址充值
2. [允许] 向合约的addToReserve函数充值
3. [允许] 通过销毁一个自建的合约，让其出现退币给TimeDelayedVault合约
4. [不允许] 通过一个自建的合约，向TimeDelayedVault合约地址直接转账操作
5. [允许] 通过一个自建的合约，向TimeDelayedVault合约的addToReserve函数充值
**选择第三种**

## 写在最后
前面的24小时，我们想得有些短了。
只想着把现有的1ETH取出来。
后来助教老师们给提示：上一期最高取出7000ETH。
所以，关于充钱和取钱的问题，需要重新考虑了。
目前充钱的方案定下来了，能瞬间完成大笔数额的充值。
但是取钱的方案没有，继续努力吧。

