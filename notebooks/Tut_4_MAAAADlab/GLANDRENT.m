function GLANDRENT(BASE)
    % Follow stata 
    top = (floor(max(BASE.r_x_C)/500) + 1) * 500;
    SHADE = BASE.URBAN .* BASE.COM * (floor(top) + 1);
    SHADEU = BASE.URBAN * (floor(top) + 1);
    
    % Plot
    figure; 
    area(BASE.x, SHADEU, 'FaceColor', [0.8 0.8 0.8]); 
    hold on; 
    area(BASE.x, SHADE, 'FaceColor', [0.6 0.6 0.6]); 
    plot(BASE.x, BASE.r_x_C, 'r--', 'LineWidth', 2); 
    plot(BASE.x, BASE.r_x_R, 'b-.', 'LineWidth', 2); 
    plot(BASE.x, BASE.r_a, 'k-', 'LineWidth', 2); 
    
    % Customize
    xlabel('');
    ylabel('Land bid rent');
    title('Land bid rent');
    legend({'Urban area', 'CBD area', 'Commercial', 'Residential', 'Agricultural'}, 'Location', 'southoutside', 'NumColumns', 5, 'FontSize', 8);
    xlim([-50 50]);
    
    maxValue = max([max(BASE.r_x_C), max(BASE.r_x_R), max(BASE.r_a)]); 
    minValue = min([min(BASE.r_x_C), min(BASE.r_x_R), min(BASE.r_a)]); 
    ylim([minValue maxValue]);

    set(gca, 'XTick', -50:10:50);
    set(gcf, 'Color', [1 1 1]); 
    set(gca, 'Box', 'off'); 
    hold off; 
end