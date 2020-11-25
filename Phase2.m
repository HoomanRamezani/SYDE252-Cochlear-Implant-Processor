
function Phase2(file_name, freq_bands, order)

    %%%%%%%%%%%%%%
    %  Phase 1   %
    %%%%%%%%%%%%%%
    % 3.1
    [samples, sampling_rate] = audioread(file_name);
    sampling_rate
    % 3.2
    channels = size(samples, 2)
    if channels==2
        samples = sum(samples(:,[1 2]),2);
    end
    % 3.3
    sound(samples, sampling_rate);
    % 3.4
    audiowrite('modified_file.wav', samples, sampling_rate)
    % 3.5
    figure(1)
    plot(samples)
    xlabel('Sample Number')
    ylabel('Signal Magnitude')
    title('Original Signal')
    ylim([-1 1])
    xlim([0 3.1*10^5])
    % 3.6
    if sampling_rate~=16000
        Fs_new = 16000;
        [numer, denom] = rat(Fs_new/sampling_rate);
        samples = resample(samples, numer, denom);
    end
%     % 3.7
%     Fs = 16000;  % sampling frequency
%     point_freq = 1/Fs;
%     freq = 1000; % frequency in hertz
%     time_duration = size(samples,1)*point_freq;
%     t = 0:point_freq:time_duration;
%     cosine_sound = cos(2*pi*freq*t);
%     %sound(cosine_sound, sampling_rate)
%     % plot two cycles
%     domain = 2/freq;
%     plot_t = 0:point_freq:domain;
%     cosine_plot = cos(2*pi*freq*plot_t);
%     figure(2)
%     plot(plot_t,cosine_plot);
%     xlabel('Time')
%     ylabel('Cosine Signal')   
%     clear
    
    %%%%%%%%%%%%%%
    %  Phase 2   %
    %%%%%%%%%%%%%%
    
    % Task 4 - Filter Design    
    % Frequency bounds
    hzLowerBound = 100;
    hzUpperBound = 8000;
    % Divide frequency into n even channels
    freqChannels = linspace(hzLowerBound, hzUpperBound, freq_bands + 1);
    % Visual representation of channel width in Hz
    % ones_matrix = ones(freq_bands + 1);    
    % figure;
    % plot(freqChannels, ones_matrix, '-o');
    % Array of 0's size (n+1)x(n+1) to store each channel of the input
    outputChannels = zeros(freq_bands, length(samples));
    
    % Task 5 - Filter the sound with the passband bank
    % Split the noise into N channels with butterworth filter
    for index = 1:freq_bands
        % Create Butterworth Filter  with the given bands.
        bw_filter = getButterworthFilter(freqChannels(index), freqChannels(index + 1), order);
        % Apply the filter the sound file
        filteredChannel = filter(bw_filter, samples);
        % Store it in the soundChannels matrix. ***** UNDERSTAND AND REWRITE
        outputChannels(index, :) = transpose(filteredChannel);
    end

    % Task 6 - Plot the output signals of the lowest and highest freq channels
    lowestChannel = outputChannels(1, :);
    highestChannel = outputChannels(freq_bands, :);
    channelLength = length(lowestChannel);
    % Plot the lowest channel
    plotChannel(channelLength, lowestChannel, 'Sample Number', 'Signal Magnitude', 'Lowest Channel');
    % Plot the highest channel
    plotChannel(channelLength, highestChannel, 'Sample Number', 'Signal Magnitude', 'Highest Channel');
   
    % Task 7 - Rectify the output signals by taking absalute value
    rectifiedOutputChannels = abs(outputChannels);
    
    % Task 8 - Envelop extraction, detect the envelopes of rectified signals using LPF with 400Fc
    % Create array for enveloped channels
    envelopedOutputChannels = zeros(freq_bands, length(samples));
    for index = 1:freq_bands
        % Filter each rectified channel using a butterworth LPF and store in envelopedOutputChannels
        envelopedOutputChannels(index, :) = filter(envelopeDetector(), rectifiedOutputChannels(index, :));
    end
        
    % Task 9 - Plot the extracted envelope of lowest and highest frequency signals
    plotChannel(channelLength, envelopedOutputChannels(1, :), 'Sample Number', 'Signal Magnitude', 'Enveloped Lowest Channel');
    plotChannel(channelLength, envelopedOutputChannels(freq_bands, :), 'Sample Number', 'Signal Magnitude', 'Enveloped Highest Channel');
end
