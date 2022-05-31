import pathlib as plib
from typing import List


def main():
    user_header_path = (
        plib.Path(__file__).parent.parent / "user-config" / "header.adoc"
    ).resolve(strict=True)

    user_header: List[str] = []
    with open(user_header_path) as f:
        user_header = f.readlines()

    # region check title and authors
    assert not user_header[0].lstrip().startswith("//"), "User header missing title."
    assert not user_header[1].lstrip().startswith("//"), "User header missing authors."
    # endregion


if __name__ == "__main__":
    main()
