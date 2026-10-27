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


END_PROMPTS = [
    ("moving arm point", 2, "same 2 points as at the start (ESC = keep tracked)"),
    ("fixed part point", 2, "same 2 points as at the start"),
]


def pick_points(frame, prompts=PROMPTS, max_w=1280):
    s = min(1.0, max_w / frame.shape[1])
    shown = cv2.resize(frame, None, fx=s, fy=s)
    pts = []
    labels = [(n, hint) for n, c, hint in prompts for _ in range(c)]

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


def template_track(prev, cur, p, r=15, search=45):
    """Fallback for points LK loses: match the previous-frame patch near the old position."""
    x, y = int(round(p[0])), int(round(p[1]))
    h, w = prev.shape
    if min(x - r, y - r) < 0 or x + r >= w or y + r >= h:
        return None
    tpl = prev[y - r:y + r + 1, x - r:x + r + 1]
    x0, y0 = max(x - search, 0), max(y - search, 0)
    win = cur[y0:min(y + search, h), x0:min(x + search, w)]
    if win.shape[0] <= tpl.shape[0] or win.shape[1] <= tpl.shape[1]:
        return None
    res = cv2.matchTemplate(win, tpl, cv2.TM_CCOEFF_NORMED)
    _, score, _, loc = cv2.minMaxLoc(res)
    return (np.float32([x0 + loc[0] + r, y0 + loc[1] + r]) if score > 0.5 else None)


def track(prev, cur, pts, lk):
    """LK with a forward-backward check; bad points fall back to template matching."""
    p0 = pts.reshape(-1, 1, 2)
    p1, st, _ = cv2.calcOpticalFlowPyrLK(prev, cur, p0, None, **lk)
    back, st2, _ = cv2.calcOpticalFlowPyrLK(cur, prev, p1, None, **lk)
    good = (st.ravel() == 1) & (st2.ravel() == 1) & (np.linalg.norm(back - p0, axis=2).ravel() < 1.5)
    new, lost = p1.reshape(-1, 2).copy(), 0
    for k in np.flatnonzero(~good):
        t = template_track(prev, cur, pts[k])
        if t is None:
            new[k], lost = pts[k], lost + 1
        else:
            new[k] = t
    return new.astype(np.float32), lost


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
    lk = dict(winSize=(41, 41), maxLevel=5,
              criteria=(cv2.TERM_CRITERIA_EPS | cv2.TERM_CRITERIA_COUNT, 30, 0.01))

    # pass 1: track every frame
    track_pts, lost, gray = [pts], 0, cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    while True:
        ok, nxt = cap.read()
        if not ok:
            break
        frame = nxt
        ng = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        pts, n = track(gray, ng, pts, lk)
        lost += int(n > 0)  # shortcut: unrecoverable points keep their last position, check the video
        track_pts.append(pts)
        gray = ng
    track_pts = np.array(track_pts)

    # click the arm and fixed points on the last frame; spread the end error linearly over the video
    try:
        end = pick_points(frame, END_PROMPTS)
        err = np.zeros((8, 2), np.float32)
        err[4:8] = end - track_pts[-1, 4:8]
        track_pts += err * np.linspace(0, 1, len(track_pts))[:, None, None]
    except SystemExit:
        pass

    # pass 2: draw
    OUT_DIR.mkdir(exist_ok=True)
    stem = Path(path).stem
    out = cv2.VideoWriter(str(OUT_DIR / f"{stem}_angle.mp4"),
                          cv2.VideoWriter_fourcc(*"mp4v"), fps, (w, h))
    cap.release()
    cap, rows = cv2.VideoCapture(path), []
    for i, pts in enumerate(track_pts):
        ok, img = cap.read()
        if not ok:
            break
        ang = hinge_angle(pts)
        rows.append((i, i / fps, ang))
        for p in pts[:4]:
            cv2.circle(img, tuple(int(v) for v in p), 3, (255, 0, 0), -1)
        cv2.polylines(img, [pts[:4].astype(np.int32)], True, (255, 0, 0), 1)
        cv2.line(img, *[tuple(int(v) for v in p) for p in pts[4:6]], (0, 0, 255), 2)
        cv2.line(img, *[tuple(int(v) for v in p) for p in pts[6:8]], (0, 255, 0), 2)
        cv2.putText(img, f"{ang:.1f} deg  t={i / fps:.2f}s", (20, 40),
                    cv2.FONT_HERSHEY_SIMPLEX, 1.1, (0, 255, 255), 3)
        out.write(img)
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
