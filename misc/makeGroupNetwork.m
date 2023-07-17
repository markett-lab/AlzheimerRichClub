

% function outputs a binary adjacency matrix where links indiate a
% connection that is present in a percentage of participants
% input connectivity matrix, use  format with dimX, dimY,
%  subjectID as format. Specify threshold thr, eg .60

function [ adj ] = makeGroupNetwork( conn, thr )
%threshold each indivdual connectivity matri at 0 to determine whether
%there's a connection or not

[x,y,subs]=size(conn);

for i=1:subs
    habin(:,:,i) = binarize_adj(conn(:,:,i),0);
end



% compute mean across group (to get percentages)

for i =1:x
    for j = 1:y
        mean_conn(i,j) = mean(habin(i,j,:));
    end
end

%threshold at .6 to get a binary adjacency matrix that is 1 if the
%connection is present in 60% of all participants and 0 otherwise

adj = binarize_adj(mean_conn,thr);

end

