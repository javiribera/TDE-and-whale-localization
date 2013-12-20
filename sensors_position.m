function sensors = sensors_position()
% SENSORS_POSITION returns the [X Y Z] position of each sensor in each row
% sensors = [X_1 Y_1 Y_1;
%            X_2 Y_2 Y_2;
%            ...]

    sensor1 = [6566 -9617 -4500];
    sensor2 = [6635 -2132 -4500];
    sensor3 = [6520 5240 -4650];
    sensor4 = [6865 12844 -4750];
    sensor5 = [-6163 -12402 -4600];
    sensor6 = [-6183 -4874 -4650];
    sensor7 = [-6129 9784 -4750];

    sensors = [ sensor1;
                sensor2;
                sensor3;
                sensor4;
                sensor5;
                sensor6;
                sensor7;
              ];

end

