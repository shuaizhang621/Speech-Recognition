function [x1,x2]=find_fragment(x)

% normalized amplitude  to[-1,1]
x=double(x);
x=x/max(abs(x));

FrameLen=240;
FrameInc=80;

amp1=10;
amp2=10;

maxsilence=30;   
minlen=15;      
status=0;
count=0;
silence=0;

tmp1 = enframe(x(1:length(x)-1),FrameLen,FrameInc);
tmp2 = enframe(x(2:length(x)),FrameLen,FrameInc);
signs = (tmp1.*tmp2)<0;
diffs = (tmp1-tmp2)>0.02;
zcr = sum(signs.*diffs,2);

amp=sum(abs(enframe(filter([1 -0.9375],1,x),FrameLen,FrameInc)),2);

amp1=min(amp1,max(amp)/4);
amp2=min(amp2,max(amp)/8);

%begin endpoint detection
x1 = 0;
x2 = 0;
for n=1:length(zcr)
  switch status
  case{0,1}         
    if amp(n)>amp1  
      x1=max(n-count-1,1);
      status=2;
      silence=0;
      count=count+1;
    elseif (amp(n)>amp2 || zcr(n)>zcr(2)) 
      status=1;
      count=count+1;
    else            
      status=0;
      count=0;
    end
  case 2,           
    if (amp(n)>amp2 || zcr(n)>zcr(2)) 
      count=count+1;
    else            
      silence=silence+1;
      if silence<maxsilence     
        count=count+1;
      elseif count<minlen       
        status=0;
        silence=0;
        count=0;
      else                      
        status=3;
      end
    end
  case 3,
    break;
  end
end

count=count-silence/2;
x2= ceil(x1+count-1);
