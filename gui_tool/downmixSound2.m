function [y1_downmix_filtered] = downmixSound2(start_freq, end_freq, y1, fs) 
%fft: http://blog.sina.com.cn/s/blog_7853c3910102vrsm.html

%f1 = 0:fs/length(y1):fs-fs/length(y1);
%t1 = 1/fs:1/fs:1/fs*length(y1);

fixed = (start_freq + end_freq) / 2;
low = start_freq - 0.5e6;
high = end_freq + 0.5e6;
downmix_f = abs(fixed - 4e6);%5-60MHz --> 4MHz

%%
%figure;
%y1_fft=fft(y1); %max = fs
%length(y1)
%length(y1_fft)
%f1 = 0:fs/length(y1):fs-fs/length(y1);
%plot(f1, y1_fft);

%%
%Bandpass-filter:
%y1_filter = bandp(y1, low, high, 350e6, 445e6, 0.1, 30, 1000e6);%need to be design
L1 = length(y1);
NFFT1 = 2^nextpow2(L1)+6;
y1_fft = fft(y1, NFFT1)/L1;
%y1_fft = fft(y1);
y1_fft(1 : floor(low * length(y1_fft) / fs)) = 0;
y1_fft(floor(high * length(y1_fft) / fs) : length(y1_fft)) = 0;
y1_filter = ifft(y1_fft);
% y1_filter = y1_filter * 5/max(abs(y1_fft));
y1_filter = y1_filter * 1e7;
% max(real(y1_fft))

%%
%downmix
t1 = 0:1/fs:1/fs*length(y1_filter)-1/fs;
downmix_sin = cos(2 * pi * downmix_f * t1);
%size(y1_filter)
%size(downmix_sin)
if size(y1_filter) ~= size(downmix_sin)
    downmix_sin = downmix_sin';
end
y1_downmix = y1_filter .* downmix_sin;

%filter low-frequency band
downmix_filter_low = 4e6 - 0.5e6 - (end_freq - start_freq)/2;
downmix_filter_high = 4e6 + 0.5e6 + (end_freq - start_freq)/2;
L1 = length(y1_downmix);
NFFT1 = 2^nextpow2(L1)+6;
y1_downmix_fft = fft(y1_downmix, NFFT1)/L1;
y1_downmix_fft(1 : floor(downmix_filter_low * length(y1_downmix_fft) / fs)) = 0;
y1_downmix_fft(floor(downmix_filter_high * length(y1_downmix_fft) / fs) : length(y1_downmix_fft)) = 0;

y1_downmix_filtered = ifft(y1_downmix_fft);
% y1_downmix_filtered = y1_downmix_filtered * 5/max(abs(y1_downmix_fft));
y1_downmix_filtered = y1_downmix_filtered * 2e7;
%%
%downsample
%just change the play_fs

% %%
% %draw figures
% figure;
% L1 = length(y1);
% NFFT1 = 2^nextpow2(L1)+6;
% y1_fft = fft(y1,NFFT1)/L1;
% f1 = (0:length(y1_fft)-1)/length(y1_fft)*fs;
% plot(f1,20*log10(2*abs(y1_fft)));
% xlim([0 fs/2]);
% xlabel('frequency domain (Hz)') % x-axis label
% ylabel('magnitude (after log)') % y-axis label
% title('original signal');
% hgsave(gcf,'..\results\downsampling\original1.fig')
% % figure
% % plot(f1,y1_fft);
% % xlim([0 fs/2]);
% % hgsave(gcf,'original2.fig')
% 
% 
% figure;
% L1 = length(y1_filter);
% NFFT1 = 2^nextpow2(L1)+6;
% y1_fft = fft(y1_filter,NFFT1)/L1;
% f1 = (0:length(y1_fft)-1)/length(y1_fft)*fs;
% plot(f1,20*log10(2*abs(y1_fft)));
% xlim([0 fs/2]);
% xlabel('frequency domain (Hz)') % x-axis label
% ylabel('magnitude (after log)') % y-axis label
% title('filtered signal');
% hgsave(gcf,'..\results\downsampling\filtered1.fig')
% % figure
% % plot(f1,y1_fft);
% % xlim([0 fs/2]);
% % hgsave(gcf,'filtered2.fig')
% 
% figure;
% % y1_downmix = downsample(y1_downmix, 2);
% L1 = length(y1_downmix);
% NFFT1 = 2^nextpow2(L1)+6;
% y1_fft = fft(y1_downmix,NFFT1)/L1;
% f1 = (0:length(y1_fft)-1)/length(y1_fft)*fs;
% plot(f1,20*log10(2*abs(y1_fft)));
% xlim([0 fs/2]);
% xlabel('frequency domain (Hz)') % x-axis label
% ylabel('magnitude (after log)') % y-axis label
% title('downmixed signal');
% hgsave(gcf,'..\results\downsampling\downmixed1.fig')
% % figure
% % plot(f1,y1_fft);
% % xlim([0 fs/2]);
% % hgsave(gcf,'downmixed2.fig')
% 
% figure;
% L1 = length(y1_downmix_filtered);
% NFFT1 = 2^nextpow2(L1)+6;
% y1_fft = fft(y1_downmix_filtered,NFFT1)/L1;
% f1 = (0:length(y1_fft)-1)/length(y1_fft)*fs;
% plot(f1,20*log10(2*abs(y1_fft)));
% xlim([0 fs/2]);
% xlabel('frequency domain (Hz)') % x-axis label
% ylabel('magnitude (after log)') % y-axis label
% title('downmixed signal');
% hgsave(gcf,'..\results\downsampling\downmixed3.fig')
% % figure
% % plot(f1,y1_fft);
% % xlim([0 fs/2]);
% % hgsave(gcf,'downmixed4.fig')
% 
% %sound(real(y1_downmix_filtered),2e3)

%%
% % draw figures 2
% % 
% figure;
% %original signal
% subplot(4,1,1);
% y1_fft = fft(y1);
% %plot(f1, 20*log10(2*abs(y1_fft)));
% f1 = (0:length(y1_fft)-1)/length(y1_fft)*fs;
% plot(f1, y1_fft);
% xlim([0 fs/2]);
% %after filter
% subplot(4,1,2);
% y1_fft = fft(y1_filter);
% % plot(f1, 20*log10(2*abs(y1_fft)));
% f1 = (0:length(y1_fft)-1)/length(y1_fft)*fs;
% plot(f1, y1_fft);
% xlim([0 fs/2]);
% %downmix
% subplot(4,1,3);
% y1_fft = fft(y1_downmix);
% % plot(f1, 20*log10(2*abs(y1_fft)));
% f1 = (0:length(y1_fft)-1)/length(y1_fft)*fs;
% plot(f1, y1_fft);
% xlim([0 fs/2]);
% %after another filter
% subplot(4,1,4);
% y1_fft = fft(y1_downmix_filtered);
% % plot(f1, 20*log10(2*abs(y1_fft)));
% f1 = (0:length(y1_fft)-1)/length(y1_fft)*fs;
% plot(f1, y1_fft);
% xlim([0 fs/2]);


%%
%demo of using bandp()
%fs=2000;
%t=(1:fs)/fs;
%ff1=100;
%ff2=400;
%ff3=700;
%x=sin(2*pi*ff1*t)+sin(2*pi*ff2*t)+sin(2*pi*ff3*t);
%figure;
%subplot(211);plot(t,x);
%subplot(212);hua_fft(x,fs,1);
%% y=filter(bz1,az1,x);
%y=bandp(x,300,500,200,600,0.1,30,fs);
%figure;
%subplot(211);plot(t,y);
%subplot(212);hua_fft(y,fs,1);