function [] = main()

disp('Loading config.json...');

% hard coded values to app config
nclust = 4;

% load my own config.json
config = loadjson('config.json');

% create output directory
mkdir('output');

% create cache dir
mkdir('cache');

%# function sptensor

%% load inputs

disp('Loading data...');

% create the labels
labs = fullfile(config.parc, 'parc.nii.gz');
mask = fullfile(config.mask, 'mask.nii.gz');
infl = config.infl;

% if these exist?
do_micro = config.compmicro;
do_tprof = config.comptprof;
do_shape = config.compshape;

nnodes = config.nnodes;
microlab = config.microdat;

if (do_micro || do_tprof)
    
    switch config.microdat
        case 'fa'
            microdat = niftiRead(config.fa);
        case 'md'
            microdat = niftiRead(config.md);
        case 'ad'
            microdat = niftiRead(config.ad);
        case 'rd'
            microdat = niftiRead(config.rd);
        otherwise
            microdat = [];
            microlab = 'none';
            do_micro = 'False';
            do_tprof = 'False';
    end

end

% import streamlines
fg = dtiImportFibersMrtrix(config.fibers, .5);

% grab length
fascicle_length = fefgGet(fg, 'length');

% create the inflated parcellation
parc = feInflateLabels(labs, mask, infl, 'vert', './output/labels_dilated.nii.gz');

%% start parallel pool

disp(['Opening parallel pool with ', num2str(nclust), ' cores...']);

% create parallel cluster object
clust = parcluster;

% set number of cores from arguments
clust.NumWorkers = nclust;

% set temporary cache directory
tmpdir = tempname('cache');

% make cache dir
OK = mkdir(tmpdir);

% check and set cachedir location
if OK
    % set local storage for parpool
    clust.JobStorageLocation = tmpdir;
    disp(['Cluster Job Storage Location set to: ' clust.JobStorageLocation]);
else
    warning('Cluster Job Storage Location was unset. The default may cause failuers.');
end

% start parpool - close parpool at end of fxn
pool = parpool(clust, nclust, 'IdleTimeout', 120);

clear tmpdir OK

%% create the inputs

disp('Assigning streamlines to connections...');

% assign the initial connections - pass dummy weights
[ pconn, rois ] = feCreatePairedConnections(parc, fg.fibers, fascicle_length, ones(size(fascicle_length)));

% catch the center in an output
centers = nan(size(rois, 1), 3);
for ii = 1:size(rois)
    centers(ii, 1) = rois{ii}.centroid.acpc(1);
    centers(ii, 2) = rois{ii}.centroid.acpc(2);
    centers(ii, 3) = rois{ii}.centroid.acpc(3);
end

clear ii 

%% central tendency of microstructure

% if microstructure central tendency is requested
if do_micro
    
    disp([ 'Computing central tendency of edge ' microlab '...' ]);
    
    % compute mean / std of microstructure property
    pconn = fnAverageEdgePropertyS(pconn, 'all', fg, microdat, microlab, 'mean');
    pconn = fnAverageEdgePropertyS(pconn, 'all', fg, microdat, microlab, 'std');
    
end

%% tract profiles

% if tract profiles are requested
if do_tprof
    
    disp([ 'Computing tract profiles of edge ' microlab '...' ]);
    
    % compute tract profiles of tensor property
    pconn = feTractProfilePairedConnections(fg, pconn, 'all', microdat, microlab, 100);
    
    % create tract profile tensor to save down
    [ ~, tpmat ] = fnTractProfileTensor(pconn, 'all', microlab);

end

%% tract curves

% if tract curvatures are requested
if do_shape
    
    disp('Computing curvature and torsion of edge...');
    
    % compute the shapes of the tracts
    pconn = fnTractCurvePairedConnections(fg, pconn, 'all', nnodes);
    
    % create tract shape tensor to save curves
    [ ~, cvmat ] = fnTractProfileTensor(pconn, 'all', 'shape.curv');
    [ ~, trmat ] = fnTractProfileTensor(pconn, 'all', 'shape.tors');

end

%% create matrices

disp('Creating connectivity matrices...');

% create the connectivty matrices
[ omat, olab ] = feCreateAdjacencyMatrices(pconn, 'all');

%% save and exit

% remove parallel pool
delete(pool);

disp('Saving outputs...');

% save the matlab outputs for debugging
save('output/omat.mat', 'omat');
save('output/olab.mat', 'olab');
save('output/pconn.mat', 'pconn');
save('output/rois.mat', 'rois');

% save text outputs - convert writes to json
dlmwrite('./output/centers.csv', centers, ',');
dlmwrite('./output/count.csv', omat(:,:,1), ',');
dlmwrite('./output/density.csv', omat(:,:,2), ',');
dlmwrite('./output/length.csv', omat(:,:,3), ',');
dlmwrite('./output/denlen.csv', omat(:,:,4), ',');

% save microstructure mats if they're made
if do_micro
    dlmwrite([ './output/' microlab '_mean.csv' ], omat(:,:,5), ',');
    dlmwrite([ './output/' microlab '_std.csv' ], omat(:,:,6), ',');
end

% save tract profiles if they're made
if do_tprof
    dlmwrite([ './output/' microlab '_tp.csv' ], tpmat, ',');
end

% save curves if they're made
if do_shape
    dlmwrite('./output/curv.csv', cvmat, ',');
    dlmwrite('./output/tors.csv', trmat, ',');
end
