// SPDX-License-Identifier: GPL-3.0
pragma solidity =0.8.7;

// contract 类似于 class 关键字
contract SixentsVote {
  // 成员变量、构造函数、成员方法等概念和其他语言保持一致

  // 声明一个可以触发的事件。里面两个参数表示相关
  event Voted(address indexed voter, uint8 proposal);

  // 声明一个map变量，里面保存用户（哈希地址）的投票情况，true 表示已投票
  mapping(address => bool) public voted;

  // 投票截止时间
  uint256 public endTime;

  // 可投票的候选人A、B、C
  uint256 public proposalA;
  uint256 public proposalB;
  uint256 public proposalC;

  // 构造函数。在合约部署到链上的时候会执行一次
  constructor(uint256 _endTime) {
    endTime = _endTime;
  }

  // 投票函数
  function vote(uint8 _proposal) public {
    // require 类似其他语言的断言，第一个参数为 false 时抛出异常
    // 要求：当前时间在截止日期前
    require(block.timestamp < endTime, 'Vote expired.');
    // 要求：被投票的人必选是 1~3
    require(_proposal >= 1 && _proposal <= 3, 'Invalid proposal.');
    // 投票地址没有投过票
    require(!voted[msg.sender], 'Cannot vote again.');

    // 记录该地址已投票
    voted[msg.sender] = true;

    // 给对应的被投票人记票
    if (_proposal == 1) {
      proposalA++;
    } else if (_proposal == 2) {
      proposalB++;
    } else if (_proposal == 3) {
      proposalC++;
    }

    // 触发 Voted 事件。事件本身没有修改数据，主要作用类似于抛出消息，让监听合约运行的第三方程序知道合约状态发生了修改
    emit Voted(msg.sender, _proposal);

    // ps:以太坊合约默认都是事务执行。如果上述任何一个执行过程异常，该方法的所有数据修改和消息发送都不会真正执行
  }

  // 获取总投票数。view 关键字修饰表示只读
  function votes() public view returns (uint256) {
    return proposalA + proposalB + proposalC;
  }
}