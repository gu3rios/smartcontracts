{\rtf1\ansi\ansicpg1252\cocoartf2867
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\froman\fcharset0 Times-Bold;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;}
{\*\expandedcolortbl;;\cssrgb\c0\c0\c0;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\partightenfactor0

\f0\b\fs24 \cf0 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 // SPDX-License-Identifier: GPL-3.0\
pragma solidity 0.8.26;\
\
contract Register01 \{\
    string private storedInfo;\
\
    function setInfo(string memory myInfo) external \{\
        storedInfo = myInfo;\
    \}\
\
    function getInfo() external view returns (string memory) \{\
        return storedInfo;\
    \}\
\}}