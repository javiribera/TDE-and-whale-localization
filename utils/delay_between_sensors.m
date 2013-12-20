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
    sensors = sensors_position(); % = [X_1 Y_1 Y_1;
                                  %    X_2 Y_2 Y_2;
                                  %    ...]
    
    distance = sqrt( sum((sensors(sensorA,:)-sensors(sensorB,:)).^2) );
    delay_secs = distance/speed;

end

