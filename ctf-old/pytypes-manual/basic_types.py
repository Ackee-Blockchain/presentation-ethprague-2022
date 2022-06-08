from typing import TypedDict, Union

from brownie.network.contract import ProjectContract
from brownie.network.account import Account

EvmAccount = Union[Account, ProjectContract]

TxnConfig = TypedDict("TxnConfig", {"from": EvmAccount})
