function GHEIGHT(BASE)
    
    % Find top as in stata
    top = (floor(max(BASE.S_x_C)/25) + 1) * 25;

    SHADE = BASE.URBAN .* BASE.COM * (floor(top/1) + 1);
    SHADEU = BASE.URBAN * (floor(top) + 1);

    maxValue = round(max(BASE.S_x_C), 25);
    stepValue = 5 * round((maxValue / 4) / 5); 

    % Plotting
    figure;
    area(BASE.x, SHADEU, 'FaceColor', [0.8 0.8 0.8]); 
    hold on; 
    area(BASE.x, SHADE, 'FaceColor', [0.6 0.6 0.6]);

    % Add lines for S_x_C and S_x_R with conditions
    plot(BASE.x, BASE.S_x_C, 'r--', 'LineWidth', 2); % Simulating color(red) and lpattern(longdash)
    plot(BASE.x(BASE.x < 0), BASE.S_x_R(BASE.x < 0), 'b-.', 'LineWidth', 2); % For x < 0, color(blue) and lpattern(shortdash)
    plot(BASE.x(BASE.x > 0), BASE.S_x_R(BASE.x > 0), 'b-.', 'LineWidth', 2); % For x > 0, repeat due to MATLAB plotting

    % Customize the graph appearance
    xlabel('');
    ylabel('Building height');
    title('Building height');
    legend({'Urban area', 'CBD area', 'Commercial', 'Residential'}, 'Location', 'southoutside', 'NumColumns', 4);
    xlim([-50 50]);
    ylim([0 maxValue]);
    set(gca, 'XTick', -50:10:50, 'YTick', 0:stepValue:maxValue);
    set(gcf, 'Color', [1 1 1]);
    set(gca, 'Box', 'off');
    hold off;
end