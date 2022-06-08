from .a_imports import *

LOGGING_LEVEL = logging.DEBUG


def config(sender: Account, value: int = 0) -> TxnConfig:
    return {"from": sender, "amount": value}


def get_logger(file_name: str, level: int) -> logging.Logger:
    logger = logging.getLogger(file_name)
    handler = logging.StreamHandler()
    formatter = logging.Formatter(
        "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
    )
    handler.setFormatter(formatter)
    logger.addHandler(handler)
    logger.setLevel(level)
    return logger


logger = get_logger(__file__, LOGGING_LEVEL)


def log(*args):
    """Useful for debuggin :-P

    https://stackoverflow.com/a/2749857/4204961"""

    frame = inspect.currentframe()
    frame = inspect.getouterframes(frame)[1]
    string = inspect.getframeinfo(frame[0]).code_context[0].strip()  # type: ignore
    params = string[string.find("(") + 1 : -1].split(",")

    names = []
    for i in params:
        if i.find("=") != -1:
            names.append(i.split("=")[1].strip())

        else:
            names.append(i)

    for name, val in zip(names, args):
        logger.debug(f"\n    {name} =\n{' ' * 14}{pprint.pformat(val)}")
