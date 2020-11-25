
% Plots signal passed in

function plotChannel(length, magnitude, x_name, y_name, plot_title)
    channel = linspace(1, length, length);
    figure;
    plot(channel, magnitude);
    xlabel(x_name);
    ylabel(y_name);
    title(plot_title)  
    % limit axis
    ylim([-1 1])
    xlim([0 3.1*10^5])
end