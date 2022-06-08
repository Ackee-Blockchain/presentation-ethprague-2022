import pathlib as plib
import keyword
import json


def sol_to_py(sol: str, input: bool) -> str:
    primitive = None

    if sol.startswith("int") or sol.startswith("uint"):
        if input:
            primitive = "Union[int, float, Decimal]"
        else:
            primitive = "int"

    if sol.startswith("contract") or sol.startswith("address"):
        primitive = "EvmAccount"

    if sol.startswith("bool"):
        primitive = "bool"

    if sol.startswith("string"):
        primitive = "str"

    if sol.startswith("bytes"):
        primitive = "bytes"

    assert primitive, f"Unexpected type: {sol}"

    if sol.endswith("[]"):
        return f"List[{primitive}]"
    else:
        return primitive


template = """from typing import Tuple, Union, List
    
from brownie.network.contract import ProjectContract
from brownie.network.transaction import TransactionReceipt

from pytypes.basic_types import *

from decimal import Decimal

"""


def main():
    file_path = plib.Path(__file__)
    abis_dir = file_path.parent / "abis"
    abi_paths = abis_dir.rglob("*.json")
    for abi_path in abi_paths:
        # file name withou all suffixes
        contract_name = abi_path.name.split(".")[0]
        target_path = file_path.parent / "custom_types" / f"{contract_name}.py"
        class_name = f"{contract_name}Type"
        res = template
        res += f"class {class_name}(ProjectContract):\n"
        abi = json.load(open(abi_path))
        for el in abi:
            try:
                if el["type"] == "function":
                    # region function_name
                    function_name = el["name"]
                    # endregion function_name

                    # region params
                    inputs = el["inputs"]
                    params = []
                    # We need to keep track of unknown parameters, so we don't name them equally
                    no_of_unknowns = 0
                    for input in inputs:
                        if not (param_name := input["name"]):
                            param_name = f"_unkown_{no_of_unknowns}"
                            no_of_unknowns += 1
                        if keyword.iskeyword(param_name):
                            param_name += "_"
                        params.append(
                            (param_name, sol_to_py(input["type"], input=True))
                        )
                        del param_name

                    del inputs

                    params_strs = (
                        ["self"]
                        + [f"{p[0]}: {p[1]}" for p in params]
                        + ["d: Union[TxnConfig, None] = None"]
                    )

                    del params

                    params_str = ", ".join(params_strs)

                    del params_strs

                    # endregion params

                    # region return_values

                    if el["stateMutability"] in ["pure", "view"]:
                        return_values = [
                            sol_to_py(output["type"], input=False)
                            for output in el["outputs"]
                        ]

                        if len(return_values) == 0:
                            return_values_str = "None"
                        elif len(return_values) == 1:
                            return_values_str = return_values[0]
                        else:
                            return_values_str = (
                                "Tuple[" + ", ".join(return_values) + "]"
                            )
                        del return_values
                    else:
                        return_values_str = "TransactionReceipt"

                    # endregion return_values

                    # region create method
                    sub = f"    def {function_name}({params_str}) -> {return_values_str}:\n"
                    res += sub + " " * 8 + "..." + "\n" * 2
                    # endregion create method

            except:
                print(f"el failed: {el}")
                raise Exception()
        # ensure parents exist
        plib.Path.mkdir(target_path.parent, parents=True, exist_ok=True)
        target_path.write_text(res)


if __name__ == "__main__":
    main()
