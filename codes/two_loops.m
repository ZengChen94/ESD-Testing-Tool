% clear all;close all; clc;
% 
% t = linspace(0, 5, 22500*5);
% y = sin(t * 1000 * 2 * pi);
% silence = zeros(1, floor(0.5e-3 * 22500));  % 0.5 ms
% size(y)
% size(silence)
% signal = [y, silence; silence, y].';
% wavplay(signal, 22050);
% % Draw the signal to check the phase shift:
% figure
% plot(signal(1:100, :))
% figure
% plot([y, silence])
% figure
% plot([silence, y])

t = (0:44100)'./44100;
y = sin(1000 * 2 * pi * t);

%left channel (switch the order of y and zeros(...) for just the right)
player = audioplayer([y, zeros(size(y))], 44100);
player.play();

% audiowrite('C:\tone.wav', [y -y], 44100);