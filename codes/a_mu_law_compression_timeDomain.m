clear all;
close all;
clc;

% load saved data
t = load('t_meas.mat');
y = load('voltage_3_chan_2.mat');

ts = t.t_meas(2)-t.t_meas(1); %2.0000e-10
fs=1/ts;

tstart = 0e-4;
tstop  = 2e-4;

[c ind1] = min(abs(t.t_meas-tstart));
[c ind2] = min(abs(t.t_meas-tstop));

fs_play = 200e3;%300e3

t1 = t.t_meas(ind1:ind2)*fs/2/fs_play;
y1 = 20*y.v2(ind1:ind2);

fname = 'sound-4-3-2';

%figure
%plot(t1,y1);
%xlim([tstart*fs/fs_play tstop*fs/fs_play]);
%xlabel('Time(s)');
%ylabel('Amplitude x20 (V)')
%grid on;

%mu-law & a-law compressor 
%http://www.mathworks.com/help/comm/ref/compand.html
%compressed = compand(y1,255,max(y1),'mu/compressor');
compressed = compand(y1,87.6,max(y1),'a/compressor');

%draw compressed
figure;
subplot(2,1,1);
plot(t1,y1);
subplot(2,1,2);
plot(t1,compressed);

%draw statistics
figure;
subplot(2,1,1);
n = hist(abs(y1),100);bar(n);
subplot(2,1,2);
n = hist(abs(compressed),100);bar(n);

% draw curve
%figure;
%plot(abs(y1), abs(compressed));

%sound(y1, fs_play);
%y = downsample(x, n)
%sound(compressed,fs_play);
%sound(y1,fs_play);
%wavwrite(compressed,fs_play,fname);

%sample
%sound(y1,fs_play);
sampled = downsample(compressed, 1e1);
sound(sampled,fs_play/10);

wavwrite(y1,fs_play,'inject_before');
wavwrite(compand(y1,255,max(y1),'mu/compressor'),fs_play,'inject_after_mu');
wavwrite(compand(y1,87.6,max(y1),'a/compressor'),fs_play,'inject_after_a');





