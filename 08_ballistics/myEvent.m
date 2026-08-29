function [value, isterminal, direction] = myEvent(t, z)
    % Stop when y (z(2)) reaches 0
    value = z(2);      % event triggered when value = 0
    isterminal = 1;    % 1 = Stop the integration, 0 = Just record it
    direction = -1;    % -1 = Only trigger when value is decreasing (falling)
end