% Frequency Spectrum Visualization for Modulated Signals
% Author: Hadi Rafat Talab
% Description: This script calculates and plots the frequency spectra of 
% message signals, carrier, and modulated signals (AM, DSB-SC, SSB).
% Carrier frequency: 1kHz, Sampling frequency: 48kHz

clear; clc;

% Parameters
fs = 48000;                     % Sampling frequency (Hz)
t = 0:1/fs:2;                   % Time vector (0 to 2 sec)
fc = 1000;                      % Carrier frequency (Hz)
Ac = 1;                          % Carrier amplitude
mu = 0.5;                        % Modulation index

% Message Signals
m1 = sin(2*pi*100*t);           % Message 1: Sinusoidal (100 Hz)
m2 = sawtooth(2*pi*100*t, 0.2); % Message 2: Sawtooth (100 Hz, 20% duty)

% Carrier Signal
c = Ac * cos(2*pi*fc*t);

% Modulation for m1
am1   = (1 + mu*m1) .* c;
dsb1  = m1 .* c;
lssb1 = ssb_modulation(m1, fc, fs, 'lower');
ussb1 = ssb_modulation(m1, fc, fs, 'upper');

% Modulation for m2
am2   = (1 + mu*m2) .* c;
dsb2  = m2 .* c;
lssb2 = ssb_modulation(m2, fc, fs, 'lower');
ussb2 = ssb_modulation(m2, fc, fs, 'upper');

% Plot frequency spectra
figure('Name','Frequency Spectrums','NumberTitle','off');

% Message 1: Sinusoidal
subplot(4,3,1)
plot_spectrum_subplot(m1, t, fs);
title('Message 1 (Sinusoidal)');

subplot(4,3,2)
plot_spectrum_subplot(c, t, fs);
title('Carrier');

subplot(4,3,3)
plot_spectrum_subplot(am1, t, fs);
title('AM (μ=0.5)');

subplot(4,3,4)
plot_spectrum_subplot(dsb1, t, fs);
title('DSB-SC');

subplot(4,3,5)
plot_spectrum_subplot(lssb1, t, fs);
title('LSSB');

subplot(4,3,6)
plot_spectrum_subplot(ussb1, t, fs);
title('USSB');

% Message 2: Sawtooth
subplot(4,3,7)
plot_spectrum_subplot(m2, t, fs);
title('Message 2 (Sawtooth)');

subplot(4,3,8)
plot_spectrum_subplot(am2, t, fs);
title('AM (μ=0.5) Sawtooth');

subplot(4,3,9)
plot_spectrum_subplot(dsb2, t, fs);
title('DSB-SC Sawtooth');

subplot(4,3,10)
plot_spectrum_subplot(lssb2, t, fs);
title('LSSB Sawtooth');

subplot(4,3,11)
plot_spectrum_subplot(ussb2, t, fs);
title('USSB Sawtooth');

%% Hilbert-based SSB Modulation Function
% Uses Hilbert transform to create analytic signal for SSB modulation
function ssb_signal = ssb_modulation(message, fc, fs, sideband)
    ht = imag(hilbert(message));
    time = (0:length(message)-1)/fs;
    if strcmp(sideband, 'upper')
        ssb_signal = real(message .* cos(2*pi*fc*time) - ht .* sin(2*pi*fc*time));
    elseif strcmp(sideband, 'lower')
        ssb_signal = real(message .* cos(2*pi*fc*time) + ht .* sin(2*pi*fc*time));
    else
        error('Sideband must be "upper" or "lower".');
    end
end

%% Spectrum Plotting Function
% Plots the single-sided magnitude spectrum for a given signal
function plot_spectrum_subplot(x, t, fs)
    t_lim = t <= 0.025;      % Limit to first 25ms window
    x_seg = x(t_lim);
    N = length(x_seg);
    f = linspace(0, fs/2, floor(N/2));
    X = fft(x_seg);
    mag = abs(X(1:floor(N/2))) / N;

    plot(f, mag);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    grid on;
    xlim([0 3000]);           % Display spectrum up to 3kHz
end
