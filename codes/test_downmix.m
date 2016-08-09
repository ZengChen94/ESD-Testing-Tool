clear all;close all; clc;

fs = 1e8;
%fs / fs_play = 500
fs_play = 200e3;
ts=1/fs;

t=(0:ts:(1e-3)/2);
fh= 1e6;

f = [fh 2*fh 3*fh 4*fh 5*fh];

y1 = sin(2*pi*f(1)*t);
y2 = sin(2*pi*f(2)*t);
y3 = sin(2*pi*f(3)*t);
y4 = sin(2*pi*f(4)*t);
y5 = sin(2*pi*f(5)*t);

y = y1 + y2 + y3 + y4 + y5;

% %plot
% plot(t,y)
% L1 = length(y);
% NFFT1 = 2^nextpow2(L1)+6;
% Y1 = fft(y,NFFT1)/L1;
% f1 = (0:length(Y1)-1)/length(Y1)*fs;
% figure
% plot(f1, 20*log10(2*abs(Y1)),'b');
% xlim([0 fs/2]);

% %detected data
% t = load('digital_frame_3K_cpu_ram/t_meas.mat');
% y = load('digital_frame_3K_cpu_ram/voltage_1_chan.mat');
% ts = t.t_meas(2)-t.t_meas(1); %time space
% fs=1/ts; %frequency
% tstart = 2e-4;
% tstop  = 3e-4;
% [c ind1] = min(abs(t.t_meas-tstart)); %ind1 = start point
% [c ind2] = min(abs(t.t_meas-tstop)); %ind2 = end point
% fs_play = 200e3;
% t1 = t.t_meas(ind1:ind2);
% y1 = 20 * y.v1(ind1:ind2);
%

wavwrite(y,fs_play,'..\results\downsampling\sound_original');

fixed = fh;
[y1_out] = downmixSound(fixed, y, fs);
y1_out2 = y1_out(1:length(y));
wavwrite(real(y1_out2),fs_play,'..\results\downsampling\sound_1');

fixed = 2*fh;
[y1_out] = downmixSound(fixed, y, fs);
y1_out2 = y1_out(1:length(y));
wavwrite(real(y1_out2),fs_play,'..\results\downsampling\sound_2');

fixed = 3*fh;
[y1_out] = downmixSound(fixed, y, fs);
y1_out2 = y1_out(1:length(y));
wavwrite(real(y1_out2),fs_play,'..\results\downsampling\sound_3');

fixed = 4*fh;
[y1_out] = downmixSound(fixed, y, fs);
y1_out2 = y1_out(1:length(y));
wavwrite(real(y1_out2),fs_play,'..\results\downsampling\sound_4');

fixed = 5*fh;
[y1_out] = downmixSound(fixed, y, fs);
y1_out2 = y1_out(1:length(y));
wavwrite(real(y1_out2),fs_play,'..\results\downsampling\sound_5');

sound(y1,fs_play)
% sound(real(y1_out2), fs_play)

