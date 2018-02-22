%dtw.m
function dist=dtw(test,ref)
% Input test matrix and reference matrix
% Output distence between test and reference
% Reference https://cn.mathworks.com/help/signal/ref/dtw.html#zmw57dd0e35991

n=size(test,1);
m=size(ref,1);
d=zeros(n,m);

for i=1:n
    for j=1:m
        d(i,j)=sum((test(i,:)-ref(j,:)).^2);
    end
end

D=ones(n,m)*realmax;
D(1,1)=d(1,1);

for i=2:n
    for j=1:m
        D1=D(i-1,j);
        if j>1
            D2=D(i-1,j-1);
        else
            D2=realmax;
        end
        if j>2
            D3=D(i-1,j-2);
        else
            D3=realmax;
        end
        D(i,j)=d(i,j)+min([D1,D2,D3]);
    end
end
dist=D(n,m);
