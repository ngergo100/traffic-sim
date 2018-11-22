classdef ChillModel
    properties
        b_max = 1.67;
    end
    
    methods
        function dy = next_step(~, ~, y, ~, ~)
            dy = [
                y(2);
                0
                ];
        end
    end
end