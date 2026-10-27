"""Hinge angle tracker.

Pick a video, click the 1 cm square's 4 corners, 2 points on the moving arm and
2 points on the fixed part. Points are tracked with optical flow; the angle is
measured in the plane of the square (homography), so perspective is corrected.
Outputs an annotated video and a CSV into ./video_output.
"""
import csv
import sys
import tkinter as tk
from pathlib import Path
from tkinter import filedialog

import cv2
import numpy as np

OUT_DIR = Path(__file__).parent / "video_output"
PX_PER_CM = 100.0  # rectified scale; only affects the homography, not the angle
SQUARE = np.float32([[0, 0], [1, 0], [1, 1], [0, 1]]) * PX_PER_CM
PROMPTS = [
    ("square corner", 4, "top-left, top-right, bottom-right, bottom-left (clockwise)"),
    ("moving arm point", 2, "1st = near hinge, 2nd = far end"),
    ("fixed part point", 2, "1st = near hinge, 2nd = far end"),
]


def pick_points(frame, max_w=1280):
    s = min(1.0, max_w / frame.shape[1])
    shown = cv2.resize(frame, None, fx=s, fy=s)
    pts = []
    labels = [(n, hint) for n, c, hint in PROMPTS for _ in range(c)]

    def on_click(event, x, y, *_):
        if event == cv2.EVENT_LBUTTONDOWN and len(pts) < len(labels):
            pts.append((x / s, y / s))

    cv2.namedWindow("select", cv2.WINDOW_NORMAL)
    cv2.setMouseCallback("select", on_click)
    while len(pts) < len(labels):
        img = shown.copy()
        for i, (x, y) in enumerate(pts):
            cv2.circle(img, (int(x * s), int(y * s)), 4, (0, 255, 0), -1)
            cv2.putText(img, str(i + 1), (int(x * s) + 6, int(y * s) - 6),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 255, 0), 2)
        name, hint = labels[len(pts)]
        cv2.putText(img, f"Click {name}: {hint}  (ESC = quit)", (10, 25),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 255, 255), 2)
        cv2.imshow("select", img)
        if cv2.waitKey(30) == 27:
            sys.exit("cancelled")
    cv2.destroyWindow("select")
    return np.float32(pts)


def hinge_angle(pts):
    """Signed angle (deg) from fixed-part line to moving-arm line, in cm-plane."""
    H = cv2.getPerspectiveTransform(pts[:4], SQUARE)
    a, b, c, d = cv2.perspectiveTransform(pts[4:].reshape(-1, 1, 2), H).reshape(-1, 2)
    arm, fixed = b - a, d - c
    return np.degrees(np.arctan2(fixed[0] * arm[1] - fixed[1] * arm[0], fixed @ arm))


def main():
    path = sys.argv[1] if len(sys.argv) > 1 else None
    if not path:
        tk.Tk().withdraw()
        path = filedialog.askopenfilename(
            title="Select video", filetypes=[("Video", "*.mp4 *.mov *.avi *.mkv *.m4v"), ("All", "*.*")])
    if not path:
        sys.exit("no video selected")

    cap = cv2.VideoCapture(path)
    ok, frame = cap.read()
    if not ok:
        sys.exit(f"cannot read {path}")
    fps = cap.get(cv2.CAP_PROP_FPS) or 30.0
    h, w = frame.shape[:2]

    pts = pick_points(frame)
    OUT_DIR.mkdir(exist_ok=True)
    stem = Path(path).stem
    out = cv2.VideoWriter(str(OUT_DIR / f"{stem}_angle.mp4"),
                          cv2.VideoWriter_fourcc(*"mp4v"), fps, (w, h))
    rows, lost = [], 0
    gray, i = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY), 0
    lk = dict(winSize=(31, 31), maxLevel=4,
              criteria=(cv2.TERM_CRITERIA_EPS | cv2.TERM_CRITERIA_COUNT, 30, 0.01))

    while True:
        ang = hinge_angle(pts)
        rows.append((i, i / fps, ang))
        img = frame.copy()
        for p in pts[:4]:
            cv2.circle(img, tuple(int(v) for v in p), 3, (255, 0, 0), -1)
        cv2.polylines(img, [pts[:4].astype(np.int32)], True, (255, 0, 0), 1)
        cv2.line(img, *[tuple(int(v) for v in p) for p in pts[4:6]], (0, 0, 255), 2)
        cv2.line(img, *[tuple(int(v) for v in p) for p in pts[6:8]], (0, 255, 0), 2)
        cv2.putText(img, f"{ang:.1f} deg  t={i / fps:.2f}s", (20, 40),
                    cv2.FONT_HERSHEY_SIMPLEX, 1.1, (0, 255, 255), 3)
        out.write(img)

        ok, frame = cap.read()
        if not ok:
            break
        ng = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        new, st, _ = cv2.calcOpticalFlowPyrLK(gray, ng, pts.reshape(-1, 1, 2), None, **lk)
        lost += int(not st.all())  # shortcut: lost points keep their last position, check the video
        pts = np.where(st.reshape(-1, 1) == 1, new.reshape(-1, 2), pts).astype(np.float32)
        gray, i = ng, i + 1

    out.release()
    with open(OUT_DIR / f"{stem}_angle.csv", "w", newline="") as f:
        wr = csv.writer(f)
        wr.writerow(["frame", "time_s", "angle_deg"])
        wr.writerows(rows)

    print(f"start angle: {rows[0][2]:.2f} deg\nend angle:   {rows[-1][2]:.2f} deg\n"
          f"change:      {rows[-1][2] - rows[0][2]:.2f} deg\noutput in {OUT_DIR}")
    if lost:
        print(f"WARNING: tracker lost a point in {lost} frames; check the video")


if __name__ == "__main__":
    main()
