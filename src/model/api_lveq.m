% =============================================================================== %
% 模型對外接口
% 定義：整合 rate_rabbit_birth、rate_fox_birth、environment_capacity、lotka_volterra
% 流程：
%   (1) 呼叫 rate_rabbit_birth、rate_fox_birth、environment_capacity 得到參數
%   (2) 呼叫 lotka_volterra 得到模式值（下一時刻的兔子、狐狸數量）
% =============================================================================== %

function next_state = api_lveq(t, now_state, past_state, dt, opt)

arguments
    t double
    now_state (:, 2) double
    past_state (:, 2) double
    dt (1, 1) double {mustBePositive}

    opt.rabbit struct = struct()
    opt.fox struct = struct()
    opt.env struct = struct()
    opt.lv struct = struct()
end

alpha = rate_rabbit_birth(t, opt.rabbit);
eta = rate_fox_birth(t, opt.fox);
K = environment_capacity(t, opt.env);
next_state = lotka_volterra(now_state, past_state, alpha, K, eta, dt, opt.lv);

end