from ._common import *

from . import a_setup


class Flows(a_setup.Setup):
    @flow
    def swap(s):
        caller = random_account(0, 3)
        token0_balance_pre = s.token0.balanceOf(caller)
        amount = random_int(0, token0_balance_pre)
        s._swap(caller, amount)

    def _swap(
        s,
        caller: Account,
        amount: int,
    ):
        s.token0.approve(s.amm, amount, config(caller))
        s.amm.swap(amount, True, config(caller))
