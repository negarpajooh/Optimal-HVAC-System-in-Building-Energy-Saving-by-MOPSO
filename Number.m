function z=Number(x)
    global NFE ;
    if isempty(NFE)
        NFE=0;
    end
    
    NFE=NFE+1;
w1=x(1)*(.74/.5);w2=x(2)*(.74/.5);
w3=x(3)*(.74/.5);w4=x(4)*(.74/.5);
B=x(5);C=x(6);Z=x(7);N=x(8);
z=abs(19-(w1.*B+w2.*C+w3.*Z+w4.*N));
% z=[B,C,Z,N];

end