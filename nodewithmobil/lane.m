function dy = lane(t, y, models)

for i=1:size(models)
  position = y(2*i-1);
  velocity = y(2*i);
  if 2*i-3 > 0
      position_leading = y(2*i-3);
      velocity_leading = y(2*i-2);
  else
      position_leading = 0;
      velocity_leading = 0;
  end
  
  findLeading(y, cat(1,models{:,4}), i);
  
  dy_ith = models{i,3}.nextStep(t, [position; velocity], position_leading, velocity_leading);
  dy(2*i-1)=dy_ith(1);
  dy(2*i)=dy_ith(2);
end

dy = dy';

end