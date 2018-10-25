classdef ChillModel
    methods
        function dy = nextStep(~, ~, y, ~, ~)
            dy = [
                y(2);
                0
                ];
        end
    end
end