clear all;
close all;
clc;

fs = 1e8;
%fs / fs_play = 500
fs_play = 200e3;
ts=1/fs;
t=(0:ts:(1e-3));
% t=(0:ts:1000*ts);
fh= 1e6;
f = [fh 2*fh 3*fh 4*fh 5*fh];
y1 = sin(2 * pi * f(2) * t);
y2 = 100 * sin(2 * pi * f(5) * t);
half_len = floor(length(t)/2);
len = length(t);
y = [y2(1:half_len), y1(len-half_len : len) + y2(len-half_len : len)];

% f = (0:length(y)-1)/length(y)*fs;
% plot(f,fft(y));
% xlim([0 fs/2]);

% %% load saved data
% t = load('t_meas.mat');
% y = load('voltage_1_chan.mat');
% ts = t.t_meas(2)-t.t_meas(1);
% fs=1/ts;
% tstart = 0.3e-3;
% tstop  = 0.8e-3;
% [c ind1] = min(abs(t.t_meas-tstart));
% [c ind2] = min(abs(t.t_meas-tstop));
% fs_play = 200e3;
% t1 = t.t_meas(ind1:ind2)*fs/fs_play;
% y1 = 20*y.v1(ind1:ind2);

%% plot original signal
% plot(t1,y1);
% xlim([tstart*fs/fs_play tstop*fs/fs_play]);
% xlabel('Time(s)');
% ylabel('Amplitude x20 (V)')
% grid on;

%% fft --> get mag / phase
L = length(y);
NFFT = 2^nextpow2(L)+6;
Y = fft(y,NFFT)/L;
f = (0:length(Y)-1)/length(Y)*fs;

Y_mag = abs(Y);
Y_phase = angle(Y);

%% mu-law & a-law compressor 
% http://www.mathworks.com/help/comm/ref/compand.html
% compressed_Y_mag = compand(Y_mag,255,max(Y_mag),'mu/compressor');
% compressed_Y_mag = compand(Y_mag,87.6,max(Y_mag),'a/compressor'); compressed_Y_mag = compressed_Y_mag';

%% log-compression
minY = min(Y_mag(find(Y_mag~=0)));
Y_mag_normalization = Y_mag / minY;
compressed_Y_mag = 20 * log(Y_mag_normalization) / log(10);
compressed_Y_mag(find(compressed_Y_mag < 250)) = 0;%mag less than threshold = 0
restruct_Y = compressed_Y_mag .* cos(Y_phase) + j * compressed_Y_mag .* sin(Y_phase);
compressed_y = ifft(restruct_Y);
compressed_y = compressed_y(1:length(y)) * 1e6;


%% result plot
%time domain
figure;
plot(t, y);
title('Original Time Domain')
xlabel('time domain (s)') % x-axis label
ylabel('magnitude') % y-axis label
hgsave(gcf,'..\results\log-compression\Original Time Domain.fig')

figure;
plot(t, compressed_y);
title('Compressed Time Domain')
xlabel('time domain (s)') % x-axis label
ylabel('magnitude') % y-axis label
hgsave(gcf,'..\results\log-compression\Compressed Time Domain.fig')

figure;
plot(f, Y);
xlim([0 fs/2]);
title('Original Frequency Domain')
xlabel('frequency domain (Hz)') % x-axis label
ylabel('magnitude') % y-axis label
hgsave(gcf,'..\results\log-compression\Original Frequency Domain.fig')

figure;
plot(f, compressed_Y_mag);
xlim([0 fs/2]);
title('Compressed Mag Frequency Domain')
xlabel('frequency domain (Hz)') % x-axis label
ylabel('magnitude') % y-axis label
hgsave(gcf,'..\results\log-compression\Compressed Mag Frequency Domain.fig')

figure;
plot(f, restruct_Y);
xlim([0 fs/2]);
title('Compressed Frequency Domain')
xlabel('frequency domain (Hz)') % x-axis label
ylabel('magnitude') % y-axis label
hgsave(gcf,'..\results\log-compression\Compressed Frequency Domain.fig')

% %draw compressed
% figure;
% subplot(2,1,1);
% plot(t,y);
% subplot(2,1,2);
% plot(t,compressed_y);

% %draw statistics
% figure;
% subplot(2,1,1);
% n = hist(abs(y1),100);bar(n);
% subplot(2,1,2);
% n = hist(abs(compressed),100);bar(n);

% %draw curve
% figure;
% plot(abs(Y1), abs(restruct_Y1));

%sound(y1, fs_play);
%y = downsample(x, n)

% sound(real(compressed_y),fs_play);
sound(real(compressed_y),fs_play);

wavwrite(y,fs_play,'..\results\log-compression\before_compressed.wav');
wavwrite(real(compressed_y),fs_play,'..\results\log-compression\after_compressed.wav');


