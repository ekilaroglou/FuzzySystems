function plots_K(idx,weights)

% % ALL
fig = figure('Position', [0 0 900 900]);
for j=1:size(weights,2)
     plot(weights(:,j))
     hold on
end
grid on;
xlabel('No of important idx'); ylabel('weight');
saveas(fig, 'weights_all','png');

% % FIRST 10
fig = figure('Position', [0 0 900 900]);
plot(weights(:,63))
hold on
plot(weights(:,66))
hold on
plot(weights(:,1))
hold on
plot(weights(:,31))
hold on
plot(weights(:,37))
hold on
plot(weights(:,69))
hold on
plot(weights(:,14))
hold on
plot(weights(:,12))
hold on
plot(weights(:,13))
hold on
plot(weights(:,57))
grid on;
xlabel('No of important idx'); ylabel('weight');
saveas(fig, 'weights_first_10','png');

% % FIRST 3
fig = figure('Position', [0 0 900 900]);
plot(weights(:,63))
hold on
plot(weights(:,66))
hold on
plot(weights(:,1))
grid on;
xlabel('No of important idx'); ylabel('weight');
saveas(fig, 'weights_first_3','png');

% we can see that weights start to stabilize at k=80
% create bar chart
idx_k_80 = idx(80,:);
weights_k_80 = weights(80,:);
fig = figure('Position', [0 0 900 900]);
bar(weights_k_80(idx_k_80))
xlabel('Predictor rank')
ylabel('Predictor importance wieght')
saveas(fig, 'bar_k_80','png');


end

