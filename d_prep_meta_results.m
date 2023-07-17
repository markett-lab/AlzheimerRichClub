
load data/regionDescriptions
cd data/metaresults

% all results files
f=dir('*csv');

% extract stats, separately for numeric and logical
for i=1:length(f)
    x=readmatrix(f(i).name,'OutputType','double','Whitespace','[]');
    meta(:,:,i)=x(2:6,[3 5 6]);
    t=readtable(f(i).name);
    meta_sign(:,i)=contains(table2cell(t(:,4)),'True');
end

% extract anatomical labels from file names
for i=1:length(f)
    metaRegions{i}=f(i).name;
    metaRegions{i}(end-3:end)=[]; % remove .csv suffix
    if matches(metaRegions{i}(2),'_')==1 % remove digit
        metaRegions{i}(1:2)=[]; % digits <10
    else
        metaRegions{i}(1:3)=[]; % digits >9
    end
end

% re-arrange labels to match connectome format: cortex
for i=1:length(f)
    if matches(metaRegions{i}(end-1:end),'_L')
        metaCortex{i}=strcat('ctx-lh-',metaRegions{i}(1:end-2));
    else
        metaCortex{i}=strcat('ctx-rh-',metaRegions{i}(1:end-2));
    end
end
% re-arrange labels to match connectome format: subcortex
for i=1:82
    if matches(regionDescriptions{i}(1:2),'Ri')
        regionCortex{i}=strcat('ctx-rh-',regionDescriptions{i}(7:end));
    elseif matches(regionDescriptions{i}(1:2),'Le')
        regionCortex{i}=strcat('ctx-lh-',regionDescriptions{i}(6:end));
    else
        regionCortex{i}=regionDescriptions{i};
    end
end

% semi-manually edit thalamus and accumbens
regionCortex=erase(regionCortex,'-Proper');
regionCortex=erase(regionCortex,'-area');

% now match
for i=1:82;
    try
        mm(i)=find(contains(metaCortex,lower(regionCortex{i})));
    catch
    mm(i)=nan;
    end
end

% apply re-ordering to results
alz_rc_meta1=meta(:,:,mm);
alz_rc_meta2=meta_sign(:,mm);

%save results
savefile='/Users/markett/Documents/projects/Alzheimer/paper/data/meta_analysis.mat'
save(savefile,"alz_rc_meta2","alz_rc_meta1")
