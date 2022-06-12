from ._common import *


class Setup:
    def __init__(
        s,
        token: TokenType,
        accounts: List[Account],
    ):
        super().__init__()
        s.token: TokenType = token.deploy()
        s.accounts = accounts
