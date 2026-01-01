% =============================================================================================== %
% 環境負載力
% 定義：可以容納的最大兔子數目，考量草糧隨季節變化，以六月為高峰
% 公式：K = K_base + K_amplitude * sin(2 * pi * t / 12 + phi), phi = pi / 2 - 2 * pi * t_peak / 12
% =============================================================================================== %

function K = environment_capacity(t)

arguments
    t double
end

K_base = 100;                               % 植被最低覆蓋率
K_amplitude = 50;                           % 植被覆蓋範圍 Range
t_peak = 6;                                 % 植被覆蓋高峰
phi = (pi / 2) - (2 * pi * t_peak / 12);    % 換算為相位

K = K_base + K_amplitude .* sin((2 * pi * t / 12) + phi);
assert(isfinite(K), "params contain NaN/Inf");

end