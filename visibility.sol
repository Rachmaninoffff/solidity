// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


contract A{
    int public x = 10;
    int y = 20;  //未指定public的state变量为internal

    function get_y() public view returns(int){
        return y;
    }

    function f1() private view returns(int){
        return x; //只可被合约内部调用，remix是外部程序，无法调用
    }

    function f2() public view returns(int){
        int a;
        a = f1();
        return a;
    }

    function f3() internal view returns(int){
        return x; //无法被外部访问，只可以被内部或者派生合约访问
    }
    
    function f4() external view returns(int){
        return x; //external 只能被合约外部访问，不可被派生子合约访问,remix是外部程序 可以访问
    }
}

contract B is A{
    int public xx = f3(); //派生出的合约可以访问父合约中的内容,可以访问internal方法
    //int public yy = f1();    子合约无法访问父合约中的private方法
    //int public dd = f4();    子合约无法访问父合约中的external方法
}

contract C{
    A public a = new A();
    int public xx = a.f4();
    //int public cc = a.f1(); not visible
    //int public cc = a.f3(); not visible
}