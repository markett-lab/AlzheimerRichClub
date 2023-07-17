cd /Users/markett/Documents/projects/Alzheimer/paper/data
load ad_richclub_results.mat

makeFigurePretty
figure
plot([1:1:28],curves(1:28,1),'-k','LineWidth',2)
xlabel('Degree Level K', 'FontSize', 18)
yyaxis left
ylabel('{\Phi} svd', 'FontSize', 20)
hold on
patch([12 27 27 12], [0 0 1 1], [0.8 0.8 0.8])
plot([1:1:28],curves(1:28,1),'-k','LineWidth',2)
hold on
plot([1:1:28],curves(1:28,2),'-','color',[105 105 105]/255,'LineWidth',2)
hold on
yyaxis right
plot([1:1:28],curves(1:28,3),'-','color',[1 0 0],'LineWidth',3)
plot([1:1:28],ones(1,28),'r--','LineWidth',2)
xlim([5 28])
yyaxis right
ylim([0 4.2])
ylabel('{\Phi} norm', 'FontSize', 18)
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',18)
box off
title('Rich Club Curves','fontsize',20)
