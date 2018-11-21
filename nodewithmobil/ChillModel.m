classdef ChillModel
    methods
        function dy = next_step(~, ~, y, ~, ~)
            dy = [
                y(2);
                0
                ];
        end
    end
end