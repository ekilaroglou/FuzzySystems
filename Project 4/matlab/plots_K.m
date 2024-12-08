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
plot(weights(:,115))
hold on
plot(weights(:,44))
hold on
plot(weights(:,51))
hold on
plot(weights(:,42))
hold on
plot(weights(:,111))
hold on
plot(weights(:,82))
hold on
plot(weights(:,116))
hold on
plot(weights(:,53))
hold on
plot(weights(:,45))
hold on
plot(weights(:,83))
grid on;
xlabel('No of important idx'); ylabel('weight');
saveas(fig, 'weights_first_10','png');

% % FIRST 3
fig = figure('Position', [0 0 900 900]);
plot(weights(:,115))
hold on
plot(weights(:,44))
hold on
plot(weights(:,51))
grid on;
xlabel('No of important idx'); ylabel('weight');
saveas(fig, 'weights_first_3','png');

% we can see that weights start to stabilize at k=120
% create bar chart
idx_k_120 = idx(120,:);
weights_k_120 = weights(120,:);
fig = figure('Position', [0 0 900 900]);
bar(weights_k_120(idx_k_120))
xlabel('Predictor rank')
ylabel('Predictor importance wieght')
saveas(fig, 'bar_k_120','png');


end

