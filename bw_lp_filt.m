function dat_filt=bw_lp_filt(dat_raw,fs,fc,time);

% Performs a butterworth low-pass filter
% dat_raw = input data
%fs = 1000;        % Sampling frequency in Hz
%fc = 40;          % Cutoff frequency in Hz
% time = time vector in seconds;

% Design a 4th-order Butterworth filter
order = 8;
Wn = fc / (fs / 2);  % Normalize the frequency
[b, a] = butter(order, Wn, 'low');

% Apply the filter to your signal
% Replace this with your actual signal
t =time;
x = dat_raw;   % Example: 10 Hz + 80 Hz
y = filtfilt(b, a, x);                % Zero-phase filtering (minimizes phase distortion and ringing)
dat_filt=y;