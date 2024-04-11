import json
import pandas as pd
import sys


def create_selection_rule(rule_id, schema_name, table_name):
    return {
        "rule-type": "selection",
        "rule-id": f"{rule_id}",
        "rule-name": f"rule-{rule_id}-schema-{schema_name}-table-{table_name}",
        "object-locator": {
            "schema-name": f"{schema_name}",
            "table-name": f"{table_name}"
        },
        "rule-action": "include"
    }


def create_mapping(table_df, starting_rule_id=1):
    return {
        "rules": [
            create_selection_rule(i + starting_rule_id, schema, table)
            for i, [schema, table] in enumerate(
                table_df.loc[:, ['schema', 'table']].values
            )
        ]
    }


def import_table_names(file_path):
    table_df = pd.read_csv(file_path, sep=',', header=0)
    if 'schema' not in table_df.columns:
        print('Expected input file to contain a "schema" column')
        exit(1)
    if 'table' not in table_df.columns:
        print('Expected input file to contain a "table" column')
        exit(1)
    return table_df


def export_table_mapping(file_path, mapping):
    with open(file_path, 'w', encoding='utf-8') as file:
        json.dump(mapping, file, ensure_ascii=False, indent=4)


if (__name__ == "__main__"):
    args = sys.argv[1:]
    if len(args) != 2:
        print(f"Incorrect number of args. Expected 2, but received {len(args)}.")  # noqa: E501
        print("Expected usage: python create_mapping.py [input_path] [output_path]")  # noqa: E501
        exit(1)
    input_path, output_path = args
    tables_by_schema = import_table_names(file_path=input_path)
    mapping = create_mapping(tables_by_schema)
    export_table_mapping(file_path=output_path, mapping=mapping)
