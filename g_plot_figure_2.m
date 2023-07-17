% this code creates figure 2 from the paper. 
% load required data:
load data/results_fig2.mat
%%
figure
tiledlayout(3,2)
    nexttile
        eb=errorbar([mean(atro_plot_max.healthy); mean(atro_plot_max.mci) ;mean(atro_plot_max.ad)]',[sem(atro_plot_max.healthy); sem(atro_plot_max.mci) ;sem(atro_plot_max.ad)]','LineWidth',2)
        xlim([.5 2.5]); xticks([1 2]); xticklabels({'periphery' 'rich club'}); ylabel('atrophy t1:t0'); ylim([0 300])
        eb(1).Marker='o';  
        eb(2).Marker='square'; eb(2).MarkerSize=10;
        eb(3).Marker='^'; eb(3).MarkerSize=10;
        for i=1:3; eb(i).MarkerFaceColor='white'; eb(i).Color=[0 0 0]; eb(i).MarkerSize=10;end
        box off
      title('>=k(max(\phi))')
    nexttile
        eb=errorbar([mean(atro_plot_min.healthy); mean(atro_plot_min.mci) ;mean(atro_plot_min.ad)]',[sem(atro_plot_min.healthy); sem(atro_plot_min.mci) ;sem(atro_plot_min.ad)]','LineWidth',2)
        xlim([.5 2.5]); xticks([1 2]); xticklabels({'periphery' 'rich club'}); ylabel('atrophy t1:t0'); ylim([0 300])
        eb(1).Marker='o';  
        eb(2).Marker='square'; eb(2).MarkerSize=10;
        eb(3).Marker='^'; eb(3).MarkerSize=10;
        for i=1:3; eb(i).MarkerFaceColor='white'; eb(i).Color=[0 0 0]; eb(i).MarkerSize=10;end
        box off
       title('>=k(min)')
    nexttile
        eb=errorbar([mean(amy_plot_max.healthy); mean(amy_plot_max.mci) ;mean(amy_plot_max.ad)]',[sem(amy_plot_max.healthy); sem(amy_plot_max.mci) ;sem(amy_plot_max.ad)]','LineWidth',2)
        xlim([.5 2.5]); xticks([1 2]); xticklabels({'periphery' 'rich club'}); ylabel('amyloid')
        eb(1).Marker='o';  
        eb(2).Marker='square'; eb(2).MarkerSize=10;
        eb(3).Marker='^'; eb(3).MarkerSize=10;
        for i=1:3; eb(i).MarkerFaceColor='white'; eb(i).Color=[0 0 0]; eb(i).MarkerSize=10;end
        box off
      %  legend({'healthy' 'mci' 'alzheimer'},'Location','northoutside','Orientation','horizontal')

    nexttile
        eb=errorbar([mean(amy_plot_min.healthy); mean(amy_plot_min.mci) ;mean(amy_plot_min.ad)]',[sem(amy_plot_min.healthy); sem(amy_plot_min.mci) ;sem(amy_plot_min.ad)]','LineWidth',2);
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