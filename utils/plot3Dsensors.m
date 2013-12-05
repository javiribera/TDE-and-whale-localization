function plot3Dsensors()
%PLOT3DSENSORS Plots the position of the sensors in the 3D space

    sensor1 = [6566 -9617 -4500]/1000;
    sensor2 = [6635 -2132 -4500]/1000;
    sensor3 = [6520 5240 -4650]/1000;
    sensor4 = [6865 12844 -4750]/1000;
    sensor5 = [-6163 -12402 -4600]/1000;
    sensor6 = [-6183 -4874 -4650]/1000;
    sensor7 = [-6129 9784 -4750]/1000;
    % in km.

    sensors = [ sensor1;
                sensor2;
                sensor3;
                sensor4;
                sensor5;
                sensor6;
                sensor7;
              ];

    figure;
    hold on;
    
    % plot sensors positions as red squares
    plot3(sensors(:,1),sensors(:,2),sensors(:,3),...
        'rs','MarkerSize',15);
    
    % indications of sensor numbers
    for i=1:7
        text(sensors(i,1),sensors(i,2),sensors(i,3),...
            num2str(i));
    end
    
    % beautify
    xlabel('x [km]'); ylabel('y [km]'); zlabel('z [km]');
    title('Location of PMRF hydrophpnes (Kauai, Hawai)')
    axis tight    
    view(70,30);
    
    % limits (aristas)
    plot3(get(gca,'XLim'),...
        min(get(gca,'YLim'))*ones(1,2),...
        min(get(gca,'ZLim'))*ones(1,2),...
        'k')
    plot3(get(gca,'XLim'),...
        max(get(gca,'YLim'))*ones(1,2),...
        min(get(gca,'ZLim'))*ones(1,2),...
        'k')
    plot3(max(get(gca,'XLim'))*ones(1,2),...
        get(gca,'YLim'),...
        min(get(gca,'ZLim'))*ones(1,2),...
        'k')
    plot3(min(get(gca,'XLim'))*ones(1,2),...
        get(gca,'YLim'),...
        min(get(gca,'ZLim'))*ones(1,2),...
        'k')
    plot3(min(get(gca,'XLim'))*ones(1,2),...
        max(get(gca,'YLim'))*ones(1,2),...
        get(gca,'ZLim'),...
        'k')
    plot3(min(get(gca,'XLim'))*ones(1,2),...
        min(get(gca,'YLim'))*ones(1,2),...
        get(gca,'ZLim'),...
        'k')
    plot3(max(get(gca,'XLim'))*ones(1,2),...
        min(get(gca,'YLim'))*ones(1,2),...
        get(gca,'ZLim'),...
        'k')
    plot3(max(get(gca,'XLim'))*ones(1,2),...
        max(get(gca,'YLim'))*ones(1,2),...
        get(gca,'ZLim'),...
        'k')
    plot3(get(gca,'XLim'),...
        min(get(gca,'YLim'))*ones(1,2),...
        max(get(gca,'ZLim'))*ones(1,2),...
        'k')
    plot3(get(gca,'XLim'),...
        max(get(gca,'YLim'))*ones(1,2),...
        max(get(gca,'ZLim'))*ones(1,2),...
        'k')
    plot3(min(get(gca,'XLim'))*ones(1,2),...
        get(gca,'YLim'),...
        max(get(gca,'ZLim'))*ones(1,2),...
        'k')
    plot3(max(get(gca,'XLim'))*ones(1,2),...
        get(gca,'YLim'),...
        max(get(gca,'ZLim'))*ones(1,2),...
        'k')
    

end

