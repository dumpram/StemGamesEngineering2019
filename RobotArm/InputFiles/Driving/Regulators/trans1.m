function y = trans1(t, coordNum, pos, vel, load_pos, load_vel, top_pos, top_vel)

% Hardcode references
actuatorRefOne = [0, 0.7, 3.4, 3.4, 6150];
actuatorRefTwo = [-135, 0.415, 3.4, 3.4, 4300];
actuatorRefThree = [-90, 0.8, 0, 0, 2000];
actuatorRefVector = [actuatorRefThree; actuatorRefOne,; actuatorRefThree; actuatorRefTwo; actuatorRefThree];

baseRef = actuatorRefVector(coordNum, 1);
rotRef = actuatorRefVector(coordNum, 2);
trans1Ref = actuatorRefVector(coordNum, 3);
trans2Ref = actuatorRefVector(coordNum, 4);
pulleyRef = actuatorRefVector(coordNum, 5);

% Measurement extraction
rotPos = pos(1);
trans1Pos = pos(2);
trans2Pos = pos(3);
baseAngle = pos(4);
pulleyAngle = pos(5);

rotVel = vel(1);
tran1Vel = vel(2);
trans2Vel = vel(3);
baseVel = vel(4);
pulleyVel = vel(5);

deltaRot = rotRef - rotPos;
if (abs(deltaRot) > 0.005)
    y = 0;
else
    deltaTrans1 = trans1Ref - trans1Pos;
    if(abs(deltaTrans1) <= 0.005)
        y = 0;
    else
        y = 0.005*sign(deltaTrans1);
    end
end

end