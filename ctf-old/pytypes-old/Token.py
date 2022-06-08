from typing import Tuple, Union, List

from brownie.network.contract import ProjectContract
from brownie.network.transaction import TransactionReceipt

from woke.m_fuzz.abi_to_type import EvmAccount, TxnConfig

from decimal import Decimal


class TokenType(ProjectContract):
    def PRICE(self, d: Union[TxnConfig, None] = None) -> int:
        ...

    def PRICE_MULTIPLIER(self, d: Union[TxnConfig, None] = None) -> int:
        ...

    def allowances(self, _unkown_0: EvmAccount, _unkown_1: EvmAccount, d: Union[TxnConfig, None] = None) -> int:
        ...

    def approve(self, spender: EvmAccount, amount: Union[int, float, Decimal], d: Union[TxnConfig, None] = None) -> TransactionReceipt:
        ...

    def balanceOf(self, usr: EvmAccount, d: Union[TxnConfig, None] = None) -> int:
        ...

    def balances(self, _unkown_0: EvmAccount, d: Union[TxnConfig, None] = None) -> int:
        ...

    def decimals(self, d: Union[TxnConfig, None] = None) -> int:
        ...

    def mint(self, d: Union[TxnConfig, None] = None) -> TransactionReceipt:
        ...

    def name(self, d: Union[TxnConfig, None] = None) -> str:
        ...

    def owner(self, d: Union[TxnConfig, None] = None) -> EvmAccount:
        ...

    def symbol(self, d: Union[TxnConfig, None] = None) -> str:
        ...

    def totalSupply(self, d: Union[TxnConfig, None] = None) -> int:
        ...

    def transfer(self, to: EvmAccount, amount: Union[int, float, Decimal], d: Union[TxnConfig, None] = None) -> TransactionReceipt:
        ...

    def transferFrom(self, from_: EvmAccount, to: EvmAccount, amount: Union[int, float, Decimal], d: Union[TxnConfig, None] = None) -> TransactionReceipt:
        ...

    def withdraw(self, value: Union[int, float, Decimal], d: Union[TxnConfig, None] = None) -> TransactionReceipt:
        ...

