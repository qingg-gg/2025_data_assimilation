% =============================================================================================== %
% 環境負載力
% 定義：可以容納的最大兔子數目，考量草糧隨季節變化，以六月為高峰
% 公式：K = K_base + K_amplitude * sin(2 * pi * t / 12 + phi), phi = pi / 2 - 2 * pi * t_peak / 12
% =============================================================================================== %

function K = environment_capacity(t, opt)

arguments
    t double
    opt.K_base (1, 1) double = 2
    opt.K_amplitude (1, 1) double = 2
end

t_peak = 6;                                 % 植被覆蓋高峰
phi = (pi / 2) - (2 * pi * t_peak / 12);    % 換算為相位
K = opt.K_base + opt.K_amplitude .* sin((2 * pi * t / 12) + phi);

end