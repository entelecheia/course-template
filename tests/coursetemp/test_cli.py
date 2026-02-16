"""
test cli module
"""
import os
import subprocess
import sys
from pathlib import Path
from typing import List, Tuple


def capture(command: List[str]) -> Tuple[bytes, bytes, int]:
    env = os.environ.copy()
    src_path = str(Path(__file__).resolve().parents[2] / "src")
    if env.get("PYTHONPATH"):
        env["PYTHONPATH"] = src_path + os.pathsep + env["PYTHONPATH"]
    else:
        env["PYTHONPATH"] = src_path
    proc = subprocess.Popen(
        command,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        env=env,
    )
    out, err = proc.communicate()
    return out, err, proc.returncode


def test_cli() -> None:
    """Test cli module"""
    command = [sys.executable, "-m", "coursetemp.__cli__", "--name", "test", "--count", "3"]
    out, err, exitcode = capture(command)
    assert exitcode == 0
