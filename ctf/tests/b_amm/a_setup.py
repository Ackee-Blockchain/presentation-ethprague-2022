from ._common import *


class Setup:
    def __init__(
        s,
        token: TokenType,
        amm: AmmType,
        accounts: List[Account],
    ):
        super().__init__()
        s.accounts = accounts
        s.token0: TokenType = token.deploy()
        s.token1: TokenType = token.deploy()
        s.amm: AmmType = amm.deploy(s.token0, s.token1)

        # give amm 100 tokens of each
        s.token0.mint(config(s.accounts[0], int(1e18)))
        s.token1.mint(config(s.accounts[0], int(1e18)))
        s.token0.transfer(s.amm, 100e18)
        s.token1.transfer(s.amm, 100e18)

        # give each user 10 token tokens each
        for i in range(3):
            s.token0.mint(config(s.accounts[i], int(1e17)))
