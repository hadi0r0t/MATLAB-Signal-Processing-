% AM Modulation Comparison with Different Modulation Indices
% Author: Your Name
% Description: This script compares AM modulation for different modulation indices.
% Carrier frequency: 1kHz, Sampling frequency: 48kHz

clear; clc;

% Parameters
fs = 48000;                     % Sampling frequency (Hz)
t = 0:1/fs:2;                   % Time vector (0 to 2 sec)
fc = 1000;                      % Carrier frequency (Hz)
Ac = 1;                         % Carrier amplitude

% Message Signal (Sinusoidal)
m = sin(2*pi*100*t);            % 100 Hz sinusoidal message

% Different modulation indices
mu_values = [0.2, 0.5, 1];      % Modulation indices to compare

% Create figure for comparison
figure('Name','AM Modulation Comparison');

for i = 1:length(mu_values)
    mu = mu_values(i);
    
    % Generate AM signal for each modulation index
    am_signal = (1 + mu * m) .* Ac .* cos(2*pi*fc*t);
    
    % Plot only first 1000 samples for better visibility
    subplot(length(mu_values), 1, i);
    plot(t(1:1000), am_signal(1:1000));
    title(['AM Modulated Signal with \mu = ', num2str(mu)]);
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;
end
