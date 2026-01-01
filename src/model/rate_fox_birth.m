% ============================================================================= %
% 轉化率
% 定義：狐狸食用一隻兔子，可以產生的狐狸數量，考量 6 月為出生率高峰
% 公式：eta = eta_amplitude * exp(-((m - m_peak)^2) / (2 * sigma^2)), m = t % 12
% ============================================================================= %

function eta = rate_fox_birth(t, y)

arguments
    t double
    y double
end

y_pregment = (y / 2) * 0.5;     % 懷孕的狐狸數量
eta_amplitude = 4 * y_pregment; eta_amplitude = eta_amplitude / y_pregment; % 狐狸每胎數量 Range
m = mod(t - 3, 12) + 1;         % 兩個月前的月份
m_peak = 6;                     % 出生率高峰（6 月）
sigma = 1.1;                    % 繁殖期（3～5 月）

eta = eta_amplitude .* exp(-((m - m_peak).^2) / (2 * sigma^2));
eta = eta / y;

end