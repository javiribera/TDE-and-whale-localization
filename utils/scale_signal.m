function output = scale_signal( input, lower, upper )
%SCALE_SIGNAL Scales signal to range [min, max].
%sound(scale_signal(data,-1,1)) is uequivalent to soundsc(data). It is
%useful to maximize the speakers audio without distorsion

    output = (input-min(input))*(upper-lower)/(max(input)-min(input))+lower;
    
end

