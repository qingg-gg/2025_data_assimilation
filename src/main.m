% ========================================================= %
% 程式切入點
% 定義：使用改良版 Lotka-Volterra 與 EnKS 進行 OSSE 試驗
% 流程：
%   (1) 設定參數
%   (2) 進行 OSSE：真值、觀測值、純模型、EnKF、EnKS（EnKF + RTS）
%   (3) 結果繪圖
% ========================================================= %

clc; clear; close all;

% Set parameters
past_state = [30, 2];
now_state = [30, 2];
months = 300;
dt = 0.01;
std_observation = 5;
R = diag(std_observation^2);
H = [1, 0];
std_model = [5, 5];
num_ensemble = 50;

% 真值
truth = zeros(2, months);
truth(:, 1) = now_state; now_state = lv_model(1, now_state, past_state, dt, now_state(1), now_state(2));
truth(:, 2) = now_state;
for i = 3: months
    past_state = truth(:, i - 2)';
    truth(:, i) = max(0, lv_model(i, truth(:, i - 1)', past_state, dt, truth(1, i - 1), truth(2, i - 1)));
end

% 觀測值
observation = zeros(1, months);
observation(1, :) = max(0, truth(1, :) + randn(1, months) * std_observation);

% 純模型
model = zeros(num_ensemble, 2, months);
model(:, 1, 1) = truth(1, 1) + randn(num_ensemble, 1) * std_model(1);
model(:, 2, 1) = truth(2, 1) + randn(num_ensemble, 1) * std_model(2);
model(:, 1, 2) = truth(1, 2) + randn(num_ensemble, 1) * std_model(1);
model(:, 2, 2) = truth(2, 2) + randn(num_ensemble, 1) * std_model(2);
for i = 3: months
    for j = 1: num_ensemble
        past_state = model(j, :, i - 2);
        model(j, :, i) = lv_model(i, model(j, :, i - 1), past_state, dt, model(j, 1, i - 1), model(j, 2, i - 1));
    end
end
model_avg = squeeze(mean(model, 1));

% EnKF
wenkf = zeros(num_ensemble, 2, months);
wenkf(:, :, 1) = enkf(model(:, :, 1), observation(:, 1), R, H);
wenkf(:, :, 2) = enkf(model(:, :, 2), observation(:, 2), R, H);
for i = 3: months
    for j = 1: num_ensemble
        past_state = wenkf(j, :, i - 2);
        wenkf(j, :, i) = lv_model(i, wenkf(j, :, i - 1), past_state, dt, wenkf(j, 1, i - 1), wenkf(j, 2, i - 1));
    end
    if mod(i, 12) == 0
        wenkf(:, :, i) = enkf(wenkf(:, :, i), observation(:, i), R, H);
    end
end
enkf_avg = squeeze(mean(wenkf, 1));

% % EnKS
wenks = zeros(num_ensemble, 2, months);
wenks(:, :, months) = wenkf(:, :, months);
for i = months - 1: -1: 1
    wenks(:, :, i) = rts(wenkf(:, :, i), wenks(:, :, i + 1), wenkf(:, :, i + 1));
end
enks_avg = squeeze(mean(wenks, 1));

% Plot results
t = 0: 1: months - 1;

figure;
subplot(1, 2, 1); hold on;
scatter(t, observation(1, :), 'white', 'Marker', '.');
plot(t, truth(1, :), 'r');
plot(t, model_avg(1, :), 'y');
plot(t, enkf_avg(1, :), 'g');
plot(t, enks_avg(1, :), 'cyan');
xlabel('Time (Month)')
ylabel('Number of Rabbits (Count)')
% legend('Observation', 'Model Truth', 'Model Only', 'EnKF', 'EnKS')

subplot(1, 2, 2); hold on;
plot(t, truth(2, :), 'r');
plot(t, model_avg(2, :), 'y');
plot(t, enkf_avg(2, :), 'g');
plot(t, enks_avg(2, :), 'cyan');
xlabel('Time (Month)')
ylabel('Number of Rabbits (Count)')
legend('Model Truth', 'Model Only', 'EnKF', 'EnKS')