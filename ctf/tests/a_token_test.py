import brownie.project
import woke.m_fuzz.fuzzer
from woke.m_fuzz import *

from .a_token.b_flows import Flows as TokenTests


def test_token(
    Token,
    accounts,
):
    accounts.default = accounts[0]
    c = Campaign(lambda: TokenTests(Token, accounts))
    c.run(sequences_count=1, flows_count=20)


if __name__ == "__main__":
    woke.m_fuzz.fuzzer._setup(8545)
    p = brownie.project.load()
    accounts = brownie.accounts
    test_token(
        p.Token,
        accounts,
    )
