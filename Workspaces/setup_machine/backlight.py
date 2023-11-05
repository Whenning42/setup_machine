#!/usr/bin/env python3

import argparse
import subprocess
from enum import Enum

class Backend(Enum):
    XBACKLIGHT = 1
    ACPI = 2


def run(cmd: str) -> str:
    return subprocess.check_output(cmd, shell=True).decode("utf-8").strip()


# Add argument for inc and dec mode
parser = argparse.ArgumentParser()
parser.add_argument("--inc", action="store_true", help="Increase the brightness")
parser.add_argument("--dec", action="store_true", help="Decrease the brightness")
parser.add_argument("--use_acpi", action="store_true", help="Use the ACPI backend. Note: This requires sudo permissions.")
args = parser.parse_args()

backend = Backend.XBACKLIGHT
if args.use_acpi:
    backend = Backend.ACPI

if backend == Backend.XBACKLIGHT:
    brightness = run("xbacklight")
    brightness = round(float(brightness))
    delta = 5
    if brightness == 0 and args.inc:
        delta = 1

    if args.inc:
        run("xbacklight -inc {} -time 0".format(delta))
    elif args.dec:
        run("xbacklight -dec {} -time 0".format(delta))

if backend == Backend.ACPI:
    brightness = int(run("cat /sys/class/backlight/intel_backlight/brightness"))
    delta = 1000
    if brightness == 0 and args.inc:
        delta = 1

    if args.dec:
        delta *= -1
    if not args.inc and not args.dec:
        exit()

    new_brightness = brightness + delta
    if new_brightness < 0:
        new_brightness = 0

    run(f"echo {new_brightness} >> /sys/class/backlight/intel_backlight/brightness")
