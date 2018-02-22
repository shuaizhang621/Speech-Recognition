function [ result ] = sr_real_time(x,ref)
%Speech recognition part 
%   This function calls the mfcc and dtw 
%   The input is test signal and ref model
%   It returns the min distance between the test signal and reference model.
K = 6;
fs = 8000;
[begining ending]=find_fragment(x);
m1=mfcc(x);
if begining-2 > 0
    m=m1(begining-2:ending-4,:);
else if begining-2< 0
        m = m1(begining:ending-2,:);
    end
end
test_mfcc=m;
%soundsc(x(begining*80,ending),fs);

distence=zeros(10,1);
dist_single = zeros(4,1);
for j=0:12
    for q = 1:K
        dist_single(q)=dtw(test_mfcc,ref(q,j+1).mfcc);
    end
    distence(j+1) = sum(dist_single)/K;
end

[d,j]=min(distence);
result = j-1;
end


