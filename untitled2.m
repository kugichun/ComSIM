function Code = OVSF(SF)
x="Input the SF value : ";
SF=input(x);

Code=1; %初始化傳的數值
Cnew=[]; %初始化一個暫存容器

for n=1:log2(SF) %SF=1,2,8,16...
    Nrow=2^n; %設定分支數量

    if Nrow == 2 %如果只有兩個分支
        Cnew = [Code Code ;Code -Code]; %OVSF規則[1 1 ; 1 -1]
        Code = Cnew; %儲存
        Cnew = []; %清空暫存容器
    else
        for ind=1:Nrow %Nrow=4,8,16...
            Cnew(ind,:)=[Code(ceil(ind/2),:),(-1)^(ind+1)*Code(ceil(ind/2),:)];
        end
        Code = Cnew; %儲存
        Cnew = [] %清空暫存容器
    end
end
Code = mat2cell(Code,ones(1,SF),SF); %將Code拆成分支 %C = mat2cell(A,dim1Dist,...,dimNDist)  A 劃分為更小的數組
%Code 轉換為 1xSF 的數組，共有SF個
end