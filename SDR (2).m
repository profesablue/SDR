
% Software Radio Initialization

% Constants for radio
FFTsize = 64;
Fs = 96000;
Ts = 1/Fs;
Fmod = Fs/4;

% Windowing Calculations for OFDM packet
k = -24:-17;
coef = 0.5*(1-cos(pi.*(k./125+0.192)./0.064));
w = [coef ones(1, 80) coef(8:-1:1)];

% Preamble Short Sequence
short_seq = (sqrt(13/6))*[0, 0, 1+j, 0, 0, 0, -1-j, 0, 0, 0, 1+j, 0, 0, 0, -1-j, 0, 0, 0, -1-j, 0, 0, 0, 1+j, 0, 0, 0, 0, 0, 0, 0, -1-j, 0, 0, 0, -1-j, 0, 0, 0, 1+j, 0, 0, 0, 1+j, 0, 0, 0, 1+j, 0, 0, 0, 1+j, 0,0];
short_seq = [zeros(1,6), short_seq, zeros(1,5)];
short_seq = [short_seq(33:64),short_seq(1:32)];
short_seq_t = ifft(short_seq);
short_seq_r = [short_seq_t, short_seq_t, short_seq_t(1:33)];

% window the preamble short sequence
short_seq_r(1) = short_seq_r(1).*0.5;
short_seq_r(161) = short_seq_r(161).*0.5;

% Assemble the whole preamble
preamble = [];
for i = 1:10,
      preamble = [preamble, short_seq_r];
end

% Add some random noise to the beginning of the preamble so things line up
l=214;
pre_sd_real = std(real(preamble));
pre_sd_imag = std(imag(preamble));
preamble_whole=[pre_sd_real*randn(1,l)+j*pre_sd_imag*randn(1,l), preamble];

% Channel Control Variables
pnoise = 0.0005;
freq_off = 10;
noiseseed = 8;
delay1 = 55;
atten1 = 0.1;
delay2inc = 2;
atten2 = 0.78;
delay3inc = 2;
atten3 = 0.25;

% Read in image for input for testing the radio
test_img = imread('sim_br_hall.jpg');
test_img = test_img(:,:,1);
data = uint8(reshape(test_img, 256*256,1));
a.time = []; %datat';
a.signals(1).values = data;
a.signals(1).dimensions = 1;

