function [ delay_secs ] = delay_between_sensors( sensorA, sensorB )
%DELAY_BETWEEN_SENSORS Gets the delay in secs between 2 sensors
%   Given underwater sound speed of 1560 m/s, delay_between_sensors(1,2)
%   returns the delay between sensors 1 and 2
%   Habra que pasarlo a muestras multiplicando por la frecuencia de muestreo
%   Util para escoger el tamano de frame minimo para calcular el delay
%   A ojo, podria ser frame_len = k (delay_max + signal_len)
    

    % underwater speed of sound in meters/seconds
    speed = 1560;

    % [X Y Z] location of each sensor in meters
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
    
    distance = sqrt( sum((sensors(sensorA,:)-sensors(sensorB,:)).^2) );
    delay_secs = distance/speed;

end

