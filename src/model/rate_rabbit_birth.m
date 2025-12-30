% ============================================================================================== %
% 獵物出生率
% 定義：兔子的出生率，考量 4 月為出生率高峰
% 公式：alpha = alpha_base + alpha_amplitude * exp(-((m - m_peak)^2) / (2 * sigma^2)), m = t % 12
% ============================================================================================== %

function alpha = rate_rabbit_birth(t, opt)

arguments
    t double
    opt.alpha_base (1, 1) double = 2
    opt.alpha_amplitude (1, 1) double = 2
end

m = mod(t - 1, 12) + 1; % 目前月份
m_peak = 4;             % 出生率高峰（4 月）
sigma = 1.75;           % 繁殖期（全年，但春季最高）
alpha = opt.alpha_base + opt.alpha_amplitude .* exp(-((m - m_peak).^2) / (2 * sigma^2));

end