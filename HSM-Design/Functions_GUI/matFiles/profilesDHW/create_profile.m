% Einzelperson
time = 0:3600:32482800;
DHW = repmat([0 0 0 0 0 0 0 6 3 3 0 6 6 0 0 0 0 0 5 0 8 15 0 0]', 376, 1);
DHW = double([time', DHW]);
save('Einzelperson.mat', 'DHW');

% Familie mit Duschen
time = 0:3600:32482800;
DHW = repmat([0 0 0 0 0 0 0 46 12 6 3 6 6 0 3 3 3 0 7 3 14 43 0 0]', 376, 1);
DHW = double([time', DHW]);
save('Familie mit Duschen.mat', 'DHW');

% Familie mit Duschen und Baden
time = 0:3600:32482800;
DHW = repmat([0 0 0 0 0 0 0 49 112 6 3 6 6 0 3 3 3 0 7 3 14 106 0 0]', 376, 1);
DHW = double([time', DHW]);
save('Familie mit Duschen und Baden.mat', 'DHW');