[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-bl.app.121-blue.svg)](https://doi.org/10.25663/brainlife.app.121)

# app-networkmatrices

This uses the FiNE MATLAB tool (release pending) to construct structural networks from a tractogram and a labeled anatomical volume. It will output multiple adjacency matrices based on user requested inputs. It will also produce edge-wise profiles of shape and microstructure properties (also based on user request). The initial version of a LiFE-less network tool.

This will be extended output .json-graph data and other types of networks as the projects around FiNE are finished and published.

The inputs are a processessed tractogram and a parcellation object.

The outputs are a series of network adjacency matrices (will be extended to .json-graph and other network file types.

### Authors
- [Brent McPherson](bcmcpher@iu.edu)

### Contributors
- [Soichi Hayashi](hayashis@iu.edu)

### Funding Acknowledgement
brainlife.io is publicly funded and for the sustainability of the project it is helpful to Acknowledge the use of the platform. We kindly ask that you acknowledge the funding below in your publications and code reusing this code.

[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-1636893](https://img.shields.io/badge/NSF_BCS-1636893-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-ACI-1916518](https://img.shields.io/badge/NSF_ACI-1916518-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1916518)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://grantome.com/grant/NIH/R01-EB029272-01)
[![NIH-NIBIB-2T32MH103213-06](https://img.shields.io/badge/NIH_NIBIB-2T32MH103213-06-green.svg)](https://grantome.com/grant/NIH/T32-MH103213-06)

### Citations
We kindly ask that you cite the following articles when publishing papers and code using this code. 

1. Avesani, P., McPherson, B., Hayashi, S. et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. Sci Data 6, 69 (2019). [https://doi.org/10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

#### MIT Copyright (c) 2020 Brent McPherson, brainlife.io, Indiana University, and The University of Texas at Austin

## Running the App 

### On Brainlife.io

You can submit this App online at [https://doi.org/10.25663/bl.app.1](https://doi.org/10.25663/bl.app.1) via the "Execute" tab.

### Running Locally (on your machine)

1. git clone this repo.
2. Inside the cloned directory, create `config.json` with something like the following content with paths to your input files.

```json
{
	"parc": "./input/parc.nii.gz",
	"track": "./input/track.tck",
	"tensor": "./input/tensor/",
	"mask": "./input/mask.nii.gz"
}
```

3. Launch the App by executing `main`

```bash
./main
```

### Sample Datasets

If you don't have your own input file, you can download sample datasets from Brainlife.io, or you can use [Brainlife CLI](https://github.com/brain-life/cli).

```
npm install -g brainlife
bl login
mkdir input
bl dataset download 5a0e604116e499548135de87 && mv 5a0e604116e499548135de87 input/parc
bl dataset download 5a0dcb1216e499548135dd27 && mv 5a0dcb1216e499548135dd27 input/track
```

## Output

All output files will be generated under the current working directory (pwd). The main output of this App is a folder called `output`. This file contains following object.

```
output:

	count.csv   - adjacency matrix file of streamline counts
	density.csv - adjacency matrix file of streamline density
	length.csv  - adjacency matrix file of streamline length
	denlen.csv  - adjacency matrix file of streamline density corrected for length

	*_mean.csv  - adjacency matrix file of average microstructure property	
	*_std.csv   - adjacency matrix file of standard deviation of microstructure property

	stats.json  - a series of network statistics estimated on the networks without thresholding.

	*_tp.csv    - a list of tract profiles (rows) of requested nodes (columns) of the requested microstructure for every edge that exists.
	curv.csv    - a list of tract profiles (rows) of requested nodes (columns) of the tract curvature for every edge that exists.
	tors.csv    - a list of tract profiles (rows) of requested nodes (columns) of the tract torsion for every edge that exists.

	centers.csv - a list of node centers in real world (X,Y,Z) mm coordinates	

	pconn.mat - MATLAB object containing connection (edge) data - for debugging / advanced offline work
	rois.mat  - MATLAB object containing ROI (node) data - for debugging / advanced offline work
	omat.mat  - MATLAB object containing matrix data - for debugging / advanced offline wor
	olab.mat  - MATLAB object containing label data - for debugging / advanced offline work

```

#### Product.json

The secondary output of this app is `product.json`. This file allows web interfaces, DB and API calls on the results of the processing. 

### Dependencies

This App only requires [singularity](https://www.sylabs.io/singularity/) to run. If you don't have singularity, you will need to install following dependencies.  

  - Matlab: https://www.mathworks.com/products/matlab.html
  - FiNE: TBA    
  - jsonlab: https://www.mathworks.com/matlabcentral/fileexchange/33381-jsonlab-a-toolbox-to-encode-decode-json-files
  - VISTASOFT: https://github.com/vistalab/vistasoft/

#### MIT Copyright (c) 2020 Brent McPherson, brainlife.io, Indiana University, and The University of Texas at Austin 
