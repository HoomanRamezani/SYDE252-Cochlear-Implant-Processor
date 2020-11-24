
function processFile(file_name)
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
    ylabel('Signal')
    
    % 3.6
    if sampling_rate~=16000
        Fs_new = 16000;
        [numer, denom] = rat(Fs_new/sampling_rate);
        samples = resample(samples, numer, denom);
    end
    
    % 3.7
    Fs = 16000;  % sampling frequency
    point_freq = 1/Fs;
    freq = 1000; % frequency in hertz
    time_duration = size(samples,1)*point_freq;
    t = 0:point_freq:time_duration;
    cosine_sound = cos(2*pi*freq*t);
    %sound(cosine_sound, sampling_rate)

    % plot two cycles
    domain = 2/freq;
    plot_t = 0:point_freq:domain;
    cosine_plot = cos(2*pi*freq*plot_t);
    figure(2)
    plot(plot_t,cosine_plot);
    xlabel('Time')
    ylabel('Cosine Signal')
    
    clear
end