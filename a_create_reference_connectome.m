
clear all

% required: 10kin1day data set. You can request the data at
% dutchconnectomelab.com
load /Users/markett/Documents/projects/10KdataArchive/10Kin1Day_dataset_aparc.mat % load dataset

%note: participants ofset_634413 have been removed (see paper)

% analyze controls only
idx=strfind(diseaseStatus,'control'); % who's a control?
controls = find(not(cellfun('isempty', idx)));
N = length(controls); %number of controls

%get number of controls per age group, also get connectivity
agecontrol=ageClass(controls);
age_groups=unique(agecontrol);

%check for gender
female=strcmp('F',gender)+strcmp('f',gender);
male=strcmp('M',gender)+strcmp('m',gender);
nosex=strcmp('NaN',gender);

for i=10:17 % age range: 55 - 90
    id=strfind(agecontrol,age_groups(i));
    id = find(not(cellfun('isempty', id)));
    n(i-9) = length(id); %number of controls per age group
    age_conn{i-9}.conn=connectivity(:,:,:,id);
    sex(i-9,1)=sum(male(id));
    sex(i-9,2)=sum(female(id));
    sex(i-9,3)=sum(nosex(id));
    clear id
end

%bring all ages 55-90 together
conn_all=cat(3,squeeze(age_conn{1}.conn(:,:,1,:)),squeeze(age_conn{2}.conn(:,:,1,:)),squeeze(age_conn{3}.conn(:,:,1,:)),squeeze(age_conn{4}.conn(:,:,1,:)),squeeze(age_conn{5}.conn(:,:,1,:)),squeeze(age_conn{6}.conn(:,:,1,:)),squeeze(age_conn{7}.conn(:,:,1,:)),squeeze(age_conn{8}.conn(:,:,6,:)));
[a,b,c]=size(conn_all);

for i=1:c
    check(i)=length(unique(isnan(conn_all(:,:,i))));
end

conn_all(:,:,find(check==2))=[]; %one participant has NaN

adj_mean = mean(conn_all,3); % mean svd
adj_bin = makeGroupNetwork(conn_all,.6); %binary matrix

adj_controls = adj_bin .* adj_mean; %add weights

cd /Users/markett/Documents/projects/Alzheimer/paper/data
save weighted_reference_connectome.mat adj_controls

