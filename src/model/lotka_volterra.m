% ==================================================================== %
% Lotka-Volterra 方程式
% 定義：狐群與兔群的數量變化關係
% 公式：
%   (1) x_rate = alpha * x(t) * (1 - x / K) - beta * x(t) * y(t)
%   (2) y_rate = eta * [beta * x(t - tau) * y(t - tau)] - gamma * y(t)
% ==================================================================== %

% Lotka-Volterra with RK4 -> 積分後得到數量
function next_state = lotka_volterra(now_state, past_state, alpha, K, eta, dt)

arguments
    now_state (:, 2) double
    past_state (:, 2) double
    alpha (1, 1) double
    K (1, 1) double
    eta (1, 1) double
    dt (1, 1) double {mustBePositive}
end

beta = 0.4;    % 狐狸狩獵成功率
gamma = 0.4;   % 狐狸死亡速率

% k1
xt = now_state;
k1 = lv_base_model(xt, past_state, alpha, K, eta, beta, gamma);

% k2
xt = now_state + k1 * (dt / 2);
k2 = lv_base_model(xt, past_state, alpha, K, eta, beta, gamma);

% k3
xt = now_state + k2 * (dt / 2);
k3 = lv_base_model(xt, past_state, alpha, K, eta, beta, gamma);

% k4
xt = now_state + k3 * dt;
k4 = lv_base_model(xt, past_state, alpha, K, eta, beta, gamma);

next_state = now_state + dt * (k1 + 2 * k2 + 2 * k3 + k4) / 6;

end

% Lotka-Volterra -> 積分前為變化率
function rate = lv_base_model(now_state, past_state, alpha, K, eta, beta, gamma)

x_now = now_state(:, 1);        % 現在的兔子數量
y_now = now_state(:, 2);        % 現在的狐狸數量
x_past = past_state(:, 1);      % 兩個月前的兔子數量
y_past = past_state(:, 2);      % 兩個月前的狐狸數量

rate = zeros(size(now_state));

rate(:, 1) = alpha .* x_now .* (1 - (x_now ./ K)) - beta .* x_now .* y_now;
rate(:, 2) = eta .* (beta .* x_past .* y_past) - gamma .* y_now;

end