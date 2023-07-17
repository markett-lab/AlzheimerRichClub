clear all

cd /Users/markett/Documents/projects/Alzheimer/paper/data
load weighted_reference_connectome.mat
load radj

% make null model
parfor i=1:10000      %executed on cluster                   
radj(i,:,:)=randmio_und(adj_controls,10);  %executed on cluster      
end  %executed on cluster  

Remp=rich_club_wu(adj_controls);


    for i=1:10000
        rrand(i,:)=rich_club_wu(squeeze(radj(i,:,:)),length(Remp)); %rc in null models
    end

for i=1:10000
    Phi_r(i,:)=Remp ./ (rrand(i,:)); % normalized rc coefficient in permutations
end

rc_pvals = 1 - (nansum(binarize_adj(Phi_r,1)) /10000); %rc_pvals
[h, crit_p, adj_p]=fdr_bh(rc_pvals,.05,'pdep','yes'); %fdr corrected

curves(:,1)=Remp';
curves(:,2)=mean(rrand);
curves(:,3)=mean(Phi_r)';
