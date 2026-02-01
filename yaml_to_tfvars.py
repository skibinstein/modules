#!/usr/bin/env python3
"""
Convert a YAML config file to Terraform tfvars.json and generate deploy files.
"""

import json
import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    print("PyYAML required. Install with: pip install PyYAML")
    sys.exit(1)


def load_yaml(path: Path) -> dict:
    """Load and parse YAML file."""
    with open(path, encoding="utf-8") as f:
        return yaml.safe_load(f)


def write_tfvars_json(data: dict, path: Path) -> None:
    """Write data as Terraform tfvars JSON with readable formatting."""
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, sort_keys=False)


def _module_keys(data: dict) -> list[str]:
    keys: list[str] = []
    for key, value in data.items():
        if isinstance(value, dict) and "source" in value:
            keys.append(key)
    return keys


def _write_file(path: Path, content: str) -> None:
    path.write_text(content.rstrip() + "\n", encoding="utf-8")


def _generate_variables_tf(data: dict, module_keys: list[str]) -> str:
    lines: list[str] = []
    lines.append('variable "project_id" {')
    lines.append("  type = string")
    lines.append("}")
    lines.append("")
    lines.append('variable "region" {')
    lines.append("  type = string")
    lines.append("}")
    if "env" in data:
        lines.append("")
        lines.append('variable "env" {')
        lines.append("  type = string")
        lines.append("}")
    for key in module_keys:
        lines.append("")
        lines.append(f'variable "{key}" {{')
        lines.append("  type = any")
        lines.append("}")
    return "\n".join(lines)


def _generate_providers_tf() -> str:
    return "\n".join(
        [
            'provider "google" {',
            "  project = var.project_id",
            "  region  = var.region",
            "}",
            "",
            'provider "google-beta" {',
            "  project = var.project_id",
            "  region  = var.region",
            "}",
        ]
    )


def _generate_versions_tf() -> str:
    return "\n".join(
        [
            "terraform {",
            '  required_version = ">= 1.14.0, < 2.0.0"',
            "  required_providers {",
            "    google = {",
            '      source  = "hashicorp/google"',
            '      version = "~> 7.16.0"',
            "    }",
            "    google-beta = {",
            '      source  = "hashicorp/google-beta"',
            '      version = "~> 7.16.0"',
            "    }",
            "  }",
            "}",
        ]
    )


def _generate_main_tf(data: dict, module_keys: list[str]) -> str:
    lines: list[str] = []
    for key in module_keys:
        source = data[key]["source"]
        lines.append(f'module "{key}" {{')
        lines.append(f'  source     = "{source}"')
        lines.append("  project_id = var.project_id")
        lines.append("  region     = var.region")
        lines.append(f"  {key}        = var.{key}")
        lines.append("}")
        lines.append("")
    return "\n".join(lines).rstrip()


def main() -> None:
    script_dir = Path(__file__).resolve().parent
    input_file = Path(sys.argv[1]) if len(sys.argv) > 1 else script_dir / "test.yaml"
    output_file = (
        Path(sys.argv[2])
        if len(sys.argv) > 2
        else script_dir / "deploy" / "terraform.tfvars.json"
    )

    if not input_file.is_absolute():
        input_file = script_dir / input_file
    if not output_file.is_absolute():
        output_file = script_dir / output_file

    if not input_file.exists():
        print(f"Error: Input file not found: {input_file}")
        sys.exit(1)

    data = load_yaml(input_file)

    deploy_dir = output_file.parent
    deploy_dir.mkdir(parents=True, exist_ok=True)

    write_tfvars_json(data, output_file)

    module_keys = _module_keys(data)
    _write_file(deploy_dir / "main.tf", _generate_main_tf(data, module_keys))
    _write_file(deploy_dir / "providers.tf", _generate_providers_tf())
    _write_file(deploy_dir / "variables.tf", _generate_variables_tf(data, module_keys))
    _write_file(deploy_dir / "versions.tf", _generate_versions_tf())

    print(f"Generated: {output_file}")


if __name__ == "__main__":
    main()
