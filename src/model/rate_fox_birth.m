% ======================================================================== %
% 轉化率
% 定義：狐狸食用一隻兔子，可以產生的狐狸數量，考量 6 月為出生率高峰
% 公式：eta = eta_base * exp(-((m - m_peak)^2) / (2 * sigma^2)), m = t % 12
% ======================================================================== %

function eta = rate_fox_birth(t, opt)

arguments
    t double
    opt.eta_base (1,1) double = 1
end

m = mod(t - 3, 12) + 1; % 兩個月前的月份
m_peak = 6;             % 出生率高峰（6 月）
sigma = 1.2;            % 繁殖期（3～5 月）
eta = opt.eta_base .* exp(-((m - m_peak).^2) / (2 * sigma^2));

end