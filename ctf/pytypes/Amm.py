from typing import Tuple, Union, List

from brownie.network.contract import ProjectContract
from brownie.network.transaction import TransactionReceipt

from woke.m_fuzz.abi_to_type import EvmAccount, TxnConfig

from decimal import Decimal


class AmmType(ProjectContract):
    def getDeltaY(self, x: Union[int, float, Decimal], y: Union[int, float, Decimal], deltaX: Union[int, float, Decimal], d: Union[TxnConfig, None] = None) -> int:
        ...

    def swap(self, amountFromUser: Union[int, float, Decimal], token1ForUser: bool, d: Union[TxnConfig, None] = None) -> TransactionReceipt:
        ...

    def token0(self, d: Union[TxnConfig, None] = None) -> EvmAccount:
        ...

    def token1(self, d: Union[TxnConfig, None] = None) -> EvmAccount:
        ...

