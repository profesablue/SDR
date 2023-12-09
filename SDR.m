% MATLAB code for Software-Defined Radio (SDR) using RTL-SDR

% Initialize RTL-SDR object
radio = comm.SDRRTLReceiver('CenterFrequency', 100e6, ...
                            'SampleRate', 2.048e6, ...
                            'SamplesPerFrame', 1024);

% Set up waterfall plot
figure;
hPlot = dsp.SpectrumAnalyzer('SampleRate', radio.SampleRate, ...
                             'SpectrumType', 'Power density', ...
                             'Title', 'RTL-SDR Spectrum', ...
                             'ShowLegend', true);

% Main loop for capturing and plotting spectrum
for i = 1:100
    % Capture radio samples
    samples = radio();

    % Plot the spectrum
    step(hPlot, samples);
end

% Release the RTL-SDR object
release(radio);
