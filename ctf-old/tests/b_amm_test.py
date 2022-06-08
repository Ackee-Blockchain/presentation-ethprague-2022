import brownie.project
import woke.m_fuzz.fuzzer
from woke.m_fuzz import *

from .b_amm.b_flows import Flows as AmmTests


def test_amm(
    Token,
    Amm,
    accounts,
):
    accounts.default = accounts[0]
    c = Campaign(lambda: AmmTests(Token, Amm, accounts))
    c.run(sequences_count=1, flows_count=20)


if __name__ == "__main__":
    woke.m_fuzz.fuzzer._setup(8545)
    p = brownie.project.load()
    accounts = brownie.accounts
    test_amm(
        p.Token,
        p.Amm,
        accounts,
    )
