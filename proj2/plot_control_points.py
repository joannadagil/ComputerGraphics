import numpy as np
import matplotlib.pyplot as plt


phase = 0.0

sway = 8 * np.sin(phase)
bowl = 10 * np.sin(phase + np.pi / 3)
waist = 7 * np.sin(phase + np.pi)

outer_ctrl = np.array([
    [200, 400],
    [200, 400],
    [200, 340],
    [200, 285],
    [200, 240 + waist],
    [200, 190],
    [200, 115],
    [200, 80],
    [200, 80],
    [300 + sway, 80],
    [430 + bowl, 80],
    [500 + bowl, 145],
    [500 + bowl, 215],
    [430 + sway, 270],
    [370, 270],
    [300, 270],
    [300, 270],
    [300, 400],
    [300, 400],
    [200, 400],
], dtype=float)

inner_ctrl = np.array([
    [300, 210],
    [300, 210],
    [300, 140],
    [300, 140],
    [340 + 0.4 * sway, 140],
    [370 + 0.6 * bowl, 140],
    [400 + 0.6 * bowl, 160],
    [400 + 0.6 * bowl, 190],
    [370 + 0.4 * bowl, 210],
    [340 + 0.3 * sway, 210],
    [300, 210],
], dtype=float)


plt.figure(figsize=(8, 6))

plt.plot(
    outer_ctrl[:, 0],
    outer_ctrl[:, 1],
    "o-",
    color="tab:blue",
    linewidth=2,
    markersize=6,
    label="outer control points",
)

plt.plot(
    inner_ctrl[:, 0],
    inner_ctrl[:, 1],
    "o-",
    color="tab:orange",
    linewidth=2,
    markersize=6,
    label="inner control points",
)

for i, (x, y) in enumerate(outer_ctrl, start=1):
    plt.text(x + 4, y, str(i), color="tab:blue", fontsize=8)

for i, (x, y) in enumerate(inner_ctrl, start=1):
    plt.text(x + 4, y, str(i), color="tab:orange", fontsize=8)

plt.xlim(0, 640)
plt.ylim(480, 0)
plt.gca().set_aspect("equal", adjustable="box")
plt.grid(True, alpha=0.3)
plt.legend()
plt.title("Letter P control points")
plt.xlabel("x [px]")
plt.ylabel("y [px]")
plt.tight_layout()
plt.savefig("control_points.png", dpi=150)
plt.show()
