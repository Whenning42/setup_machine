import argparse
import subprocess


def run(cmd):
    return subprocess.check_output(cmd, shell=True).decode("utf-8").strip()


# Add argument for inc and dec mode
parser = argparse.ArgumentParser()
parser.add_argument("--inc", action="store_true", help="increase the brightness")
parser.add_argument("--dec", action="store_true", help="decrease the brightness")
args = parser.parse_args()

brightness = run("xbacklight")
brightness = round(float(brightness))
delta = 10
if brightness == 0 and args.inc:
    delta = 1

if args.inc:
    run("xbacklight -inc {} -time 0".format(delta))
elif args.dec:
    run("xbacklight -dec {} -time 0".format(delta))
