%Convert robot units from meters to millimeters


Hhand2world_=Hhand2world;
for i=1:numPoses
    Hhand2world_(1:3,4,i)=Hhand2world(1:3,4,i).*1000;
end
