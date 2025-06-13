% Modulation Project - Time Domain Visualization
% Author: Hadi Rafat Talab
% Description: This script implements AM, DSB-SC, and SSB modulations
% for two message signals: sinusoidal and sawtooth.
% Carrier frequency: 1kHz, Sampling frequency: 48kHz

clear; clc;

% Parameters
fs = 48000;             % Sampling frequency (Hz)
t = 0:1/fs:2;           % Time vector (0 to 2 sec)
fc = 1000;              % Carrier frequency (Hz)
Ac = 1;                 % Carrier amplitude
mu = 0.5;               % Modulation index for AM

% Message Signals
m1 = sin(2*pi*100*t);                 % Message 1: Sinusoidal (100 Hz)
m2 = sawtooth(2*pi*100*t, 0.2);       % Message 2: Sawtooth (100 Hz, 20% duty)

% Carrier Signal
c = Ac*cos(2*pi*fc*t);

% Modulation for m1
am1 = (1 + mu*m1) .* c;               % AM modulation
dsb1 = m1 .* c;                       % DSB-SC modulation
lssb1 = ssb_modulation(m1, fc, fs, 'lower');  % Lower Sideband SSB
ussb1 = ssb_modulation(m1, fc, fs, 'upper');  % Upper Sideband SSB

% Modulation for m2
am2 = (1 + mu*m2) .* c; 
dsb2 = m2 .* c;
lssb2 = ssb_modulation(m2, fc, fs, 'lower');
ussb2 = ssb_modulation(m2, fc, fs, 'upper');

% Limit the time axis to 0 - 0.025 seconds for better visualization
t_plot = t(t <= 0.025);
idx = find(t <= 0.025);

% Crop signals for plotting
m1_plot = m1(idx); m2_plot = m2(idx); c_plot = c(idx);
am1_plot = am1(idx); dsb1_plot = dsb1(idx); lssb1_plot = lssb1(idx); ussb1_plot = ussb1(idx);
am2_plot = am2(idx); dsb2_plot = dsb2(idx); lssb2_plot = lssb2(idx); ussb2_plot = ussb2(idx);

%% Plotting Modulation Results for Message 1 (Sinusoidal)
figure('Name','Signal 1: Sinusoidal');
subplot(3,2,1); plot(t_plot, m1_plot); title('Message Signal 1: sin(2\pi100t)');
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,2,2); plot(t_plot, c_plot); title('Carrier Signal');
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,2,3); plot(t_plot, am1_plot); title('AM Modulated (\mu=0.5)');
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,2,4); plot(t_plot, dsb1_plot); title('DSB-SC');
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,2,5); plot(t_plot, lssb1_plot); title('Lower Sideband SSB (LSSB)');
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,2,6); plot(t_plot, ussb1_plot); title('Upper Sideband SSB (USSB)');
xlabel('Time (s)'); ylabel('Amplitude');

%% Plotting Modulation Results for Message 2 (Sawtooth)
figure('Name','Signal 2: Sawtooth');
subplot(3,2,1); plot(t_plot, m2_plot); title('Message Signal 2: Sawtooth');
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,2,2); plot(t_plot, c_plot); title('Carrier Signal');
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,2,3); plot(t_plot, am2_plot); title('AM Modulated (\mu=0.5)');
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,2,4); plot(t_plot, dsb2_plot); title('DSB-SC');
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,2,5); plot(t_plot, lssb2_plot); title('Lower Sideband SSB (LSSB)');
xlabel('Time (s)'); ylabel('Amplitude');

subplot(3,2,6); plot(t_plot, ussb2_plot); title('Upper Sideband SSB (USSB)');
xlabel('Time (s)'); ylabel('Amplitude');

%% Hilbert-based SSB Modulation Function
% Since Communications Toolbox is not available, Hilbert transform is used.
function ssb_signal = ssb_modulation(message, fc, fs, sideband)
    ht = imag(hilbert(message)); % Generate analytic signal using Hilbert transform
    time = (0:length(message)-1)/fs;
    if strcmp(sideband, 'upper')
        ssb_signal = real(message .* cos(2*pi*fc*time) - ht .* sin(2*pi*fc*time));
    elseif strcmp(sideband, 'lower')
        ssb_signal = real(message .* cos(2*pi*fc*time) + ht .* sin(2*pi*fc*time));
    else
        error('Sideband must be "upper" or "lower".');
    end
end
