function ccc=mfcc(x)
% Calculate MFC for x

p = 24;
n = 256;
fs = 8000;
fl = 0;
fh = 0.5;
w1 = 'm';

if nargin < 6
   w1='tz';
   if nargin < 5
     fh=0.5;
     if nargin < 4
       fl=0;
     end
   end
end

f0=700/fs;
fn2=floor(n/2);
lr=log((f0+fh)/(f0+fl))/(p+1);
 
bl=n*((f0+fl)*exp([0 1 p p+1]*lr)-f0);
b2=ceil(bl(2));
b3=floor(bl(3));
if any(w1=='y')
    pf=log((f0+(b2:b3)/n)/(f0+fl))/lr;
    fp=floor(pf);
    r=[ones(1,b2) fp fp+1 p*ones(1,fn2-b3)];
    c=[1:b3+1 b2+1:fn2+1];
    v=2*[0.5 ones(1,b2-1) 1-pf+fp pf-fp ones(1,fn2-b3-1) 0.5];
    mn=1;
    mx=fn2+1;
else
    b1=floor(bl(1))+1;
    b4=min(fn2,ceil(bl(4)))-1;
    pf=log((f0+(b1:b4)/n)/(f0+fl))/lr;
    fp=floor(pf);
    pm=pf-fp;
    k2=b2-b1+1;
    k3=b3-b1+1;
    k4=b4-b1+1;
    r=[fp(k2:k4) 1+fp(1:k3)];
    c=[k2:k4 1:k3];
    v=2*[1-pm(k2:k4) pm(1:k3)];
    mn=b1+1;
    mx=b4+1;
end
if any(w1=='n')
    v=1-cos(v*pi/2);
elseif any(w1=='m')
    v=1-0.92/1.08*cos(v*pi/2);
end
if nargout > 1
    bank=sparse(r,c,v);
else
    bank=sparse(r,c+mn-1,v,p,1+fn2);
end

bank=full(bank);
bank=bank/max(bank(:));

for k=1:12
  n=0:23;
  dctcoef(k,:)=cos((2*n+1)*k*pi/(2*24));
end

w=1+6*sin(pi*[1:12]./12);
w=w/max(w);

xx=double(x);
xx=filter([1 -0.9375],1,xx);
xx=enframe(xx,256,80);
for i=1:size(xx,1)
  y=xx(i,:);
  s=y'.*hamming(256);
  t=abs(fft(s));
  t=t.^2;
  c1=dctcoef*log(bank*t(1:129));
  c2=c1.*w';
  m(i,:)=c2';
end
dtm=zeros(size(m));
for i=3:size(m,1)-2
  dtm(i,:)=-2*m(i-2,:)-m(i-1,:)+m(i+1,:)+2*m(i+2,:);
end
dtm=dtm/3;

ccc=[m dtm];
ccc=ccc(3:size(m,1)-2,:);
