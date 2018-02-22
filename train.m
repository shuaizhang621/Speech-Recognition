K = 6
for k=1:K
for i=0:12
    fname=sprintf('/Users/zhangshuai/Desktop/Speech_Recognition/data/train/en_t%d/T_%d.wav',k,i);
    x=audioread(fname);
    [x1 x2]=vad(x);
    m1=mfcc(x);
    fs = 8000;
    if x1-2 > 0
        m=m1(x1-2:x2-4,:);
    else if x1-2< 0
        m = m1(x1:x2-2,:);
    end
    end
    ref(k,i+1).mfcc=m;
end  
end