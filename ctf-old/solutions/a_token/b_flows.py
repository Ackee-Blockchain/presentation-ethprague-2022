from ._common import *

from . import a_setup


class Flows(a_setup.Setup):
    @flow
    @weight(100)  # default weight = 100
    @max_times(10)
    def mint(s):
        caller = random_account(0, 5)
        value = random_int(int(1e18), int(10e18))
        s._mint(caller, value)

    def _mint(s, caller: Account, value: int):
        balance_pre = s.token.balanceOf(caller)

        callers_balance_pre = caller.balance()

        s.token.mint(config(caller, value))

        callers_balance_post = caller.balance()

        balance_post = s.token.balanceOf(caller)
        expected_increase = value * 100

        assert math.isclose(
            balance_post - balance_pre,
            expected_increase,
            rel_tol=0.01,
        ), f"Expected increase of {expected_increase} but got {balance_post - balance_pre}"

    @flow
    @weight(50)
    def withdraw(s):
        s._withdraw()

    def _withdraw(s):
        owners_balance_pre = s.accounts[0].balance()
        tokens_balance_pre = s.token.balance()
        s.token.withdraw()
        owners_balance_post = s.accounts[0].balance()
        assert (
            owners_balance_post - owners_balance_pre == tokens_balance_pre
        ), f"Expected {owners_balance_post} - {owners_balance_pre} == {tokens_balance_pre}"
