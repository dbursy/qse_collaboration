function GBIDRENT(BASE)
    % top as in stata
    top = (floor(max(BASE.p_bar_x_C)/5) + 1) * 5;
    
    SHADE = BASE.URBAN .* BASE.COM * floor(top/1);
    SHADEU = BASE.URBAN * floor(top);
    
    % Plot
    figure;
    area(BASE.x, SHADEU, 'FaceColor', [0.8 0.8 0.8]);
    hold on; 
    area(BASE.x, SHADE, 'FaceColor', [0.6 0.6 0.6]); 
    plot(BASE.x, BASE.p_bar_x_C, 'r--', 'LineWidth', 2);
    plot(BASE.x(BASE.x > 0), BASE.p_bar_x_R(BASE.x > 0), 'b-.', 'LineWidth', 2); 
    plot(BASE.x(BASE.x < 0), BASE.p_bar_x_R(BASE.x < 0), 'b-.', 'LineWidth', 2); 
    
    % Customize
    xlabel('');
    ylabel('Floor space rent');
    title('Floor space rent');
    legend({'Urban area', 'CBD area', 'Commercial', 'Residential'}, 'Location', 'southoutside', 'NumColumns', 4);
    xlim([-50 50]);
    set(gca, 'XTick', -50:10:50);
    set(gcf, 'Color', [1 1 1]);
    set(gca, 'Box', 'off');
    hold off;
end