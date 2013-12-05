function plot3Dsensors()
%PLOT3DSENSORS Plots the position of the sensors in the 3D space

    sensor1 = [6566 -9617 -4500]/1000; % in km.
    sensor2 = [6635 -2132 -4500]/1000;
    sensor3 = [6520 5240 -4650]/1000;
    sensor4 = [6865 12844 -4750]/1000;
    sensor5 = [-6163 -12402 -4600]/1000;
    sensor6 = [-6183 -4874 -4650]/1000;
    sensor7 = [-6129 9784 -4750]/1000;
    % in meters

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
    
%     for i=1:7
%         plot3(sensors(i,1),sensors(i,2),sensors(i,3),'r')
%     end

    plot3(sensors(:,1),sensors(:,2),sensors(:,3),...
        'rx','MarkerSize',10);
    xlabel('x [km]'); ylabel('y [km]'); zlabel('z [km]');
    view(70,30);

end

