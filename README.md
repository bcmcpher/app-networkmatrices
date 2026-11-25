<h1 align="center">Network Matrices</h1>

<p align="center">
  Builds structural network adjacency matrices (streamline count, density, length and optional tensor-based edge weights and tract profiles) from a tractogram and a volumetric parcellation with the FiNE MATLAB tool.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/brainlife.app.121"><img src="https://img.shields.io/badge/Brainlife-brainlife.app.121-blue.svg" alt="Run on brainlife.io"></a>
</p>

## At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Builds structural network adjacency matrices (streamline count, density, length and optional tensor-based edge weights and tract profiles) from a tractogram and a volumetric parcellation with the FiNE MATLAB tool.**

Dilates the parcellation labels into white matter within the brain mask, assigns streamlines to node pairs and writes adjacency matrices of streamline count, density, length and length-corrected density, plus network statistics. Optionally adds mean/std FA, MD, AD or RD per edge, tract profiles along edges, and edge curvature and torsion. Use it to build connectomes for network analysis; tract profiles need more memory and runtime. Tractogram, parcellation, mask and tensor maps must be in the same space.

| | |
|---|---|
| **Inputs** | `neuro/parcellation/volume` · `neuro/track/tck` · `neuro/tensor` (optional) · `neuro/mask` |
| **Outputs** | `raw` |
| **Container** | `brainlife/mcr:neurodebian1604-r2017a` |
| **Run it** | [doi.org/10.25663/brainlife.app.121](https://doi.org/10.25663/brainlife.app.121) |

#### Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `1` | `neuro/parcellation/volume` | yes | The nodes to build the networks |
| `2` | `neuro/track/tck` | yes | The streamlines to create the edges |
| `3` | `neuro/tensor` | no | You can request average microstructure properties (FA/MD/AD/RD) or tract profiles for edge weights. |
| `mask` | `neuro/mask` | yes | Brain mask used to inflate the label slightly into the white matter so that we can capture more fibers that don't quite enter the gray matter volume. You can feed the mask output from Multi-atlas transfer tool App, or run FSL Brain extraction App. The mask should not include the ventricle. |

#### Outputs

| Output | Datatype | Description |
|---|---|---|
| `1` | `raw` | Directory of CSV adjacency matrices (count, density, length, denlen, optional *_mean/*_std), optional tract profiles (*_tp.csv, curv.csv, tors.csv), node centres, network stats.json and MATLAB .mat objects of edges, ROIs and matrices. |

<details>
<summary><b>Parameters</b> (6)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `infl` | number | `2` | The number of voxels to dilate the labels into white matter. |
| `microdat` | enum |  | Optionally select which microstructure measure to summarize Options: `fa`, `md`, `ad`, `rd`. |
| `compshape` | boolean | `false` | Compute curvature and torsion of edges |
| `compmicro` | boolean | `false` | Compute mean / std of optional tensor property |
| `comptprof` | boolean | `false` | Compute tract profile of optional tensor property (requires more memory and runtime) |
| `nnodes` | number | `100` | The number of points to re-sample to for computing edge curves and tract profiles |

</details>

<!-- brainlife-app:end -->

## Running the App

### On brainlife.io

Open the App at [doi.org/10.25663/brainlife.app.121](https://doi.org/10.25663/brainlife.app.121), choose `neuro/parcellation/volume`, `neuro/track/tck`, `neuro/tensor`, `neuro/mask` from your project, set the parameters and press **Execute**. The results are saved to your project as `raw`.

### Locally

You need [Singularity/Apptainer](https://apptainer.org/) (the App runs in `brainlife/mcr:neurodebian1604-r2017a`), [`jq`](https://jqlang.github.io/jq/).

1. Clone this repository.
2. Create `config.json` with the paths to your inputs and the parameters:

   ```json
   {
       "parc": "/path/to/1/parc",
       "key": "/path/to/1/key",
       "fibers": "/path/to/2/fibers",
       "fa": "/path/to/3/fa",
       "md": "/path/to/3/md",
       "rd": "/path/to/3/rd",
       "ad": "/path/to/3/ad",
       "mask": "/path/to/mask/mask",
       "infl": 2,
       "microdat": "",
       "compshape": false,
       "compmicro": false,
       "comptprof": false,
       "nnodes": 100
   }
   ```

3. Run `./main`.

## Troubleshooting

- **output missing**: The network build did not produce pconn.mat; check the inputs and, for tract profiles, the memory available.

## Sample Datasets

If you don't have your own input file, you can download sample datasets from Brainlife.io, or you can use [Brainlife CLI](https://github.com/brainlife/cli).

```
npm install -g brainlife
bl login
mkdir input
bl dataset download 5a0e604116e499548135de87 && mv 5a0e604116e499548135de87 input/parc
bl dataset download 5a0dcb1216e499548135dd27 && mv 5a0dcb1216e499548135dd27 input/track
```

## Citing

If you use this App, please cite it, the software it builds on and brainlife.io:

- Network Matrices. brainlife.io App. [doi:10.25663/brainlife.app.121](https://doi.org/10.25663/brainlife.app.121)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. *Scientific Data* 6:69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

## Authors

- Brent McPherson

**Contributors**

- Soichi Hayashi

## Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io, which runs this App, is publicly funded by Wellcome, the U.S. National Institutes of Health and the U.S. National Science Foundation; acknowledging that support helps keep it running.</sub>
