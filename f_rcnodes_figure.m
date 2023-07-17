%% requirements:
%BCT (Brain Connectivity toolbox)
%   Enigma Toolbox
%% load data
load data/weighted_reference_connectome.mat
load data/regionDescriptions.mat

% compute degree
deg=degrees_und(adj_controls);

% compute rc vector for plotting (color codes for actual rc (.75) and total
% rc regime  (-.75)
rcvec=zeros(82,1);
rcvec(deg>=12)=-0.75;
rcvec(deg>=26)=0.75;

% bring subcortical in ENIGMA order:
[a,b]=sort(regionDescriptions(1:14));
rcsb=rcvec(1:14);
%% plot
addpath(genpath('~/Documents/imaging/ENIGMA'))
% parcel to cortical surface
p2s=parcel_to_surface(rcvec(15:82));
% make figure
figure;
plot_cortical(p2s,'color_range',[-1 1])
plot_subcortical(rcsb(b),'ventricles','False','color_range',[-1 1])