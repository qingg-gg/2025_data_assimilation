% ============================================================================================== %
% 獵物出生率
% 定義：兔子的出生率，考量 4 月為出生率高峰
% 公式：alpha = alpha_base + alpha_amplitude * exp(-((m - m_peak)^2) / (2 * sigma^2)), m = t % 12
% ============================================================================================== %

function alpha = rate_rabbit_birth(t, x)

arguments
    t double
    x double
end

x_pregment = (x / 2) * 0.5;         % 懷孕的兔子數量
alpha_base = 2 * x_pregment; alpha_base = alpha_base / x_pregment;       % 兔子每胎最少數量
alpha_amplitude = 8 * x_pregment; alpha_amplitude = alpha_amplitude / x_pregment;  % 兔子每胎數量 Range
m = mod(t - 1, 12) + 1;             % 目前月份
m_peak = 4;                         % 出生率高峰（4 月）
sigma = 2.5;                        % 繁殖期（全年，但春季最高）

alpha = alpha_base + alpha_amplitude .* exp(-((m - m_peak).^2) / (2 * sigma^2));

end