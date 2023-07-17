% this code creates figure 2 from the paper. 
% load required data:
load data/results_fig2.mat
%%
figure
tiledlayout(3,2)
    nexttile
        eb=errorbar([atmax(1,:,1); atmax(2,:,1) ;atmax(3,:,1)]',[atmax(1,:,2); atmax(2,:,2) ;atmax(3,:,2)]','LineWidth',2)
        xlim([.5 2.5]); xticks([1 2]); xticklabels({'periphery' 'rich club'}); ylabel('atrophy t1:t0'); ylim([0 300])
        eb(1).Marker='o';  
        eb(2).Marker='square'; eb(2).MarkerSize=10;
        eb(3).Marker='^'; eb(3).MarkerSize=10;
        for i=1:3; eb(i).MarkerFaceColor='white'; eb(i).Color=[0 0 0]; eb(i).MarkerSize=10;end
        box off
      title('>=k(max(\phi))')
    nexttile
        eb=errorbar([atmin(1,:,1); atmin(2,:,1) ;atmin(3,:,1)]',[atmin(1,:,2); atmin(2,:,2) ;atmin(3,:,2)]','LineWidth',2)
        xlim([.5 2.5]); xticks([1 2]); xticklabels({'periphery' 'rich club'}); ylabel('atrophy t1:t0'); ylim([0 300])
        eb(1).Marker='o';  
        eb(2).Marker='square'; eb(2).MarkerSize=10;
        eb(3).Marker='^'; eb(3).MarkerSize=10;
        for i=1:3; eb(i).MarkerFaceColor='white'; eb(i).Color=[0 0 0]; eb(i).MarkerSize=10;end
        box off
       title('>=k(min)')
    nexttile
        eb=errorbar([ammax(1,:,1); ammax(2,:,1) ;ammax(3,:,1)]',[ammax(1,:,2); ammax(2,:,2) ;ammax(3,:,2)]','LineWidth',2)
        xlim([.5 2.5]); xticks([1 2]); xticklabels({'periphery' 'rich club'}); ylabel('amyloid')
        eb(1).Marker='o';  
        eb(2).Marker='square'; eb(2).MarkerSize=10;
        eb(3).Marker='^'; eb(3).MarkerSize=10;
        for i=1:3; eb(i).MarkerFaceColor='white'; eb(i).Color=[0 0 0]; eb(i).MarkerSize=10;end
        box off
      %  legend({'healthy' 'mci' 'alzheimer'},'Location','northoutside','Orientation','horizontal')

    nexttile
        eb=errorbar([ammin(1,:,1); ammin(2,:,1) ;ammin(3,:,1)]',[ammin(1,:,2); ammin(2,:,2) ;ammin(3,:,2)]','LineWidth',2);
        xlim([.5 2.5]); xticks([1 2]); xticklabels({'periphery' 'rich club'}); ylabel('amyloid')
        eb(1).Marker='o';  
        eb(2).Marker='square'; eb(2).MarkerSize=10;
        eb(3).Marker='^'; eb(3).MarkerSize=10;
        for i=1:3; eb(i).MarkerFaceColor='white'; eb(i).Color=[0 0 0]; eb(i).MarkerSize=10;end
        box off
        legend({'healthy' 'mci' 'alzheimer'},'Location','northoutside','Orientation','horizontal')

     nexttile
         eb=errorbar([squeeze(bfs(16,2,1,:)) squeeze(bfs(16,1,1,:))],[squeeze(bfs(16,2,2,:)) squeeze(bfs(16,1,2,:))],'LineWidth',2)
         xlim([.5 5.5]); xticks([1:5]); xticklabels({'alzheimer' 'alzheimer \newline disease' 'mild \newline cognitive' 'mci' 'cognitive \newline impairment' }); ylabel('bayes factor'); ; ylim([.7 1.35])
         eb(1).Marker='o';  eb(2).Marker='^';
         for i=1:2; eb(i).MarkerFaceColor='white'; eb(i).Color=[0 0 0]; eb(i).MarkerSize=10;end
    box off

     nexttile
        eb=errorbar([squeeze(bfs(1,2,1,:)) squeeze(bfs(1,1,1,:))],[squeeze(bfs(16,2,2,:)) squeeze(bfs(16,1,2,:))],'LineWidth',2)
        xlim([.5 5.5]); xticks([1:5]); xticklabels({'alzheimer' 'alzheimer \newline disease' 'mild \newline cognitive' 'mci' 'cognitive \newline impairment' }); ylabel('bayes factor'); ylim([.7 1.35])
        eb(1).Marker='o';  eb(2).Marker='^';
        for i=1:2; eb(i).MarkerFaceColor='white'; eb(i).Color=[0 0 0]; eb(i).MarkerSize=10;end
        box off
        legend(eb,{'periphery' 'rich club'},'Location','northoutside','Orientation','horizontal')

%% export figure
addpath ~/Documents/batches/altmany-export_fig-bdf6154/
set(gcf,'color','w');
export_fig('/Users/markett/Documents/projects/Alzheimer/paper/alzheimer_figure_2','-pdf') 
