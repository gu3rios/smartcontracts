{\rtf1\ansi\ansicpg1252\cocoartf2867
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\fs24 \cf0 // SPDX-License-Identifier: MIT\
\
pragma solidity >=0.8.2 <0.9.0;\
\
contract safemultisig \{\
    struct Transaction \{\
        address payable spender;\
        uint amount;\
        uint numberOfApproval;\
        bool isActive;\
    \}\
\
    address[] Admins;\
    uint constant MINIMUM = 3;\
    uint transactionId;\
    mapping(address => bool) isAdmin;\
    mapping(uint => Transaction) transaction;\
    mapping(uint => mapping(address => bool)) hasApproved;\
\
    error InvalidAddress(uint position);\
    error InvalidAdminNumber(uint number);\
    error duplicate(address _addr);\
\
    event Create(address who, address spender, uint amount);\
\
    modifier onlyAdmin()\{\
        require(isAdmin[msg.sender], "Nao e um administrador valido");\
        _;\
    \}\
\
    constructor(address[] memory _admins) payable \{\
        if (_admins.length < MINIMUM)\{\
            revert InvalidAdminNumber(MINIMUM);\
        \}\
\
        for (uint i = 0; i < _admins.length; i++)\{\
            if (_admins[i] == address(0))\{\
                revert InvalidAddress(i + 1);\
            \}\
\
            if (isAdmin[_admins[i]])\{\
                revert duplicate(_admins[i]);\
            \}\
\
            isAdmin[_admins[i]] = true;\
        \}\
\
        Admins = _admins;\
    \}\
\
    function createTransaction(uint amount, address _spender) external payable onlyAdmin\{\
        require(msg.value == amount, "Valor fornecido diferente da transacao");\
        transactionId++;\
        Transaction storage _transaction = transaction[transactionId];\
        _transaction.amount = amount;\
        _transaction.spender = payable(_spender);\
        _transaction.isActive = true;\
        emit Create(msg.sender, _spender, amount);\
        approveTransaction(transactionId);\
    \}\
\
    function approveTransaction(uint id) public onlyAdmin\{\
        require(!hasApproved[id][msg.sender], "Ja aprovado!");\
        Transaction storage _transaction = transaction[id];\
        require(_transaction.isActive, "Nao esta ativa");\
        _transaction.numberOfApproval += 1;\
        hasApproved[id][msg.sender] = true;\
        uint count = _transaction.numberOfApproval;\
        uint MinApp = calculateMinimumApproval();\
        if (count >= MinApp)\{\
            sendTransaction(id);\
        \}\
    \}\
\
    function sendTransaction(uint id) private\{\
        Transaction storage _transaction = transaction[id];\
        _transaction.spender.transfer(_transaction.amount);\
        _transaction.isActive = false;\
    \}\
\
    function calculateMinimumApproval() private view returns(uint MinApp)\{\
        uint size = Admins.length;\
        MinApp = (size * 70)/100;\
    \}\
\
    function getTransaction(uint id) external view returns(Transaction memory)\{\
        return transaction[id];\
    \}\
\}}