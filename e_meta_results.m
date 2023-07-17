load data/meta_analysis.mat
load data/weighted_reference_connectome.mat

addpath ~/Documents/imaging/BCT/2017_01_15_BCT/

k=12:27;

% bayes factors:
for i=1:length(k)
    for j=1:5
        bfs(i,1,1,j)=mean(alz_rc_meta1(j,3,find(degrees_und(adj_controls)>=k(i))));
        bfs(i,2,1,j)=mean(alz_rc_meta1(j,3,find(degrees_und(adj_controls)<k(i))));
        bfs(i,1,2,j)=sem(alz_rc_meta1(j,3,find(degrees_und(adj_controls)>=k(i))));
        bfs(i,2,2,j)=sem(alz_rc_meta1(j,3,find(degrees_und(adj_controls)<k(i))));
    end
end

savefile='/Users/markett/Documents/projects/Alzheimer/paper/data/meta_bayesfactors.mat'
save(savefile, 'bfs')

% chi square
for i=1:length(k)
    for j=1:5
            [~,chip(i,j,1),chip(i,j,2)]=crosstab(alz_rc_meta2(j,:)',(degrees_und(adj_controls)>=k(i))');
    end
end
% -> all p>.05!


