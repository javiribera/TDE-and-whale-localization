% Calcula el delay maximo [en segundos]
% que puede haber entre los sensores proporcionados.
% Habra que pasarlo a muestras multiplicando por la frecuencia de muestreo
% Util para escoger el tamano de frame minimo para calcular el delay
% A ojo, podria ser frame_len = k (2*delay_max + signal_len)

% underwater speed of sound in meters/seconds
speed = 1560;

% [X Y Z] location of each sensor in meters
sensors = sensors_position(); % = [X_1 Y_1 Y_1;
                              %    X_2 Y_2 Y_2;
                              %    ...]
      
max_distance = 0;
for i=1:7
    for j=1:7
        distance = sqrt( sum((sensors(i,:)-sensors(j,:)).^2) );
        if (distance > max_distance)
            max_distance = distance;
            farsensor1 = i;
            farsensor2 = j;
        end
    end
end

max_delay = max_distance/speed;

clear i j distance sensors sensor* speed