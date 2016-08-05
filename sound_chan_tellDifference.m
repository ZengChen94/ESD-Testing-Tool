clear all;
close all;
clc;

% load saved data
t = load('..\sony_data\1.inject_touch_and_freeze_screen\t_meas.mat');
y = load('..\sony_data\1.inject_touch_and_freeze_screen\voltage_3_chan_2.mat');

ts = t.t_meas(2)-t.t_meas(1);
fs=1/ts;

tstart = 0e-4;
tstop  = 2e-4;
tmiddle = 1e-4;

tstart_before = 0e-4;
tstop_before = 0.8e-4;
tstart_after = 1.2e-4;
tstop_after = 2e-4;

tstart_before1 = 0e-4;
tstop_before1 = 0.5e-4;
tstart_before2 = 0.5e-4;
tstop_before2 = 1e-4;


[c ind1] = min(abs(t.t_meas-tstart));
[c ind2] = min(abs(t.t_meas-tstop));
[c ind3] = min(abs(t.t_meas-tmiddle));

[c ind4] = min(abs(t.t_meas-tstart_before));
[c ind5] = min(abs(t.t_meas-tstop_before));
[c ind6] = min(abs(t.t_meas-tstart_after));
[c ind7] = min(abs(t.t_meas-tstop_after));

[c ind8] = min(abs(t.t_meas-tstart_before1));
[c ind9] = min(abs(t.t_meas-tstop_before1));
[c ind10] = min(abs(t.t_meas-tstart_before2));
[c ind11] = min(abs(t.t_meas-tstop_before2));

fs_play = 200e3;

t1 = t.t_meas(ind1:ind2)*fs/fs_play;
y1 = 20*y.v2(ind1:ind2);

t1_before = t.t_meas(ind4:ind5)*fs/fs_play;
y1_before = 20*y.v2(ind4:ind5);

t1_after = t.t_meas(ind6:ind7)*fs/fs_play;
y1_after = 20*y.v2(ind6:ind7);

t1_before1 = t.t_meas(ind8:ind9)*fs/fs_play;
y1_before1 = 20*y.v2(ind8:ind9);

t1_before2 = t.t_meas(ind10:ind11)*fs/fs_play;
y1_before2 = 20*y.v2(ind10:ind11);

figure;
L1 = length(y1);
NFFT1 = 2^nextpow2(L1)+6;
y1_fft = fft(y1, NFFT1)/L1;
f1 = 0:fs/length(y1_fft):fs-fs/length(y1_fft);
plot(f1, y1_fft);
title('beforeESD+afterESD');
xlabel('frequency domain (Hz)') % x-axis label
ylabel('magnitude') % y-axis label
xlim([0 fs/2]);
figure
plot(t1,y1);
xlim([tstart*fs/fs_play tstop*fs/fs_play]);
xlabel('Time(s)');
ylabel('Amplitude x20 (V)')
title('beforeESD+afterESD');
grid on;

figure;
L1 = length(y1_before);
NFFT1 = 2^nextpow2(L1)+6;
y1_fft_before = fft(y1_before, NFFT1)/L1;
f1 = 0:fs/length(y1_fft_before):fs-fs/length(y1_fft_before);
plot(f1, y1_fft_before);
title('beforeESD');
xlabel('frequency domain (Hz)') % x-axis label
ylabel('magnitude') % y-axis label
xlim([0 fs/2]);
figure
plot(t1_before,y1_before);
xlim([tstart_before*fs/fs_play tstop_before*fs/fs_play]);
xlabel('Time(s)');
ylabel('Amplitude x20 (V)')
title('beforeESD');
grid on;

figure;
L1 = length(y1_after);
NFFT1 = 2^nextpow2(L1)+6;
y1_fft_after = fft(y1_after, NFFT1)/L1;
f1 = 0:fs/length(y1_fft_after):fs-fs/length(y1_fft_after);
plot(f1, y1_fft_after);
title('afterESD');
xlabel('frequency domain (Hz)') % x-axis label
ylabel('magnitude') % y-axis label
xlim([0 fs/2]);
figure
plot(t1_after,y1_after);
xlim([tstart_after*fs/fs_play tstop_after*fs/fs_play]);
xlabel('Time(s)');
ylabel('Amplitude x20 (V)')
title('afterESD');
grid on;

figure
y1_tmp =y1_fft_before-y1_fft_after; 
plot(f1,y1_tmp);xlim([0 fs/2]);
title('beforeESD-afterESD');
xlabel('frequency domain (Hz)') % x-axis label
ylabel('magnitude') % y-axis label

figure;
L1 = length(y1_before1);
NFFT1 = 2^nextpow2(L1)+6;
y1_fft_before1 = fft(y1_before1, NFFT1)/L1;
f1 = 0:fs/length(y1_fft_before1):fs-fs/length(y1_fft_before1);
plot(f1, y1_fft_before1);
title('beforeESD1');
xlabel('frequency domain (Hz)') % x-axis label
ylabel('magnitude') % y-axis label
xlim([0 fs/2]);

figure;
L1 = length(y1_before2);
NFFT1 = 2^nextpow2(L1)+6;
y1_fft_before2 = fft(y1_before2, NFFT1)/L1;
f1 = 0:fs/length(y1_fft_before2):fs-fs/length(y1_fft_before2);
plot(f1, y1_fft_before2);
title('beforeESD2');
xlabel('frequency domain (Hz)') % x-axis label
ylabel('magnitude') % y-axis label
xlim([0 fs/2]);

figure
y1_tmp =y1_fft_before1/max(y1_fft_before1)-y1_fft_before2/max(y1_fft_before2); 
plot(f1,y1_tmp);xlim([0 fs/2]);
title('beforeESD-afterESD');
xlabel('frequency domain (Hz)') % x-axis label
ylabel('magnitude') % y-axis label


% xlim([0 fs/2]);
fname = '..\sony_data\1.inject_touch_and_freeze_screen\sound-4-3-2';
sound(y1,fs_play);%fs_play means the neighbor space is 1/fs_play s
wavwrite(y1,fs_play,fname);

