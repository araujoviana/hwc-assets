# HWC Assets

Presentation backgrounds and visual assets for Huawei Cloud, organized by product/service. Maintained by Solutions Architects for use in workshops and customer engagements.

## Structure

```
hwc-assets/
├── DataArtsStudio/   # Data governance & analytics backgrounds
├── Flexus/           # Flexus compute backgrounds
├── HuaweiCloud/      # General HWC branded backgrounds
├── MaaS/             # Model-as-a-Service backgrounds
├── ModelArts/        # AI/ML platform backgrounds
├── MRS/              # MapReduce Service backgrounds
├── TaurusDB/         # TaurusDB backgrounds
└── optimize.sh       # Batch resizing/optimization script
```

Raw originals (too large for GitHub) stay local. `ppt-backgrounds/` contains the 1920×1080 JPEGs ready to drop into PowerPoint — these are what's tracked in git.

## Regenerating outputs

Requires [ImageMagick](https://imagemagick.org/) (`magick` CLI). Run from repo root after adding new raw assets:

```bash
./optimize.sh
```

Output lands in `ppt-backgrounds/` (tracked in git). Raw source folders are gitignored.

## Asset Guidelines

- **Format:** JPEG for photos/backgrounds, SVG for icons/diagrams
- **Branding:** Follow official Huawei Cloud brand guidelines (colors, fonts, icons)
- **Resolution:** 1920×1080 minimum for presentation use
