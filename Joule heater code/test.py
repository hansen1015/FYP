import argparse
import serial

parser = argparse.ArgumentParser(description="Listen on a serial port and print incoming data.")
parser.add_argument("--port", type=str, default="COM6", help="Serial port (default: /dev/ttyUSB0)")
parser.add_argument("--baud", type=int, default=9600, help="Baud rate (default: 9600)")
args = parser.parse_args()

print(f"Listening on {args.port} at {args.baud} baud...")

with serial.Serial(args.port, args.baud, timeout=1) as ser:
    while True:
        line = ser.readline()
        if line:
            print(f"Data: {line.decode(errors='replace').strip()}")