background_classroom=imread('C:\Users\yangdongdong\Desktop\工程\sample\6.jpg');
%imshow(Initial_background);
%impixelinfo;figure;
normal_classroom=imread('C:\Users\yangdongdong\Desktop\工程\sample\01.jpg');
%some seat which are seated.
ST=background_classroom;
%imshow(background_classroom),impixelinfo;
X=normal_classroom;
Ist=rgb2hsv(ST);
I1=rgb2hsv(X);
Hst=Ist(:,:,1);
H1=I1(:,:,1);
S1=I1(:,:,2);
Sst=Ist(:,:,2);
Vst=Ist(:,:,3);
V1=I1(:,:,3);
%imshow(X),impixelinfo,figure;
%title('原始图像');
num_st=size(Vst);
mean_st=sum((sum(Vst)))/(num_st(1)*num_st(2));
num1=size(V1);
mean1=sum((sum(V1)))/(num1(1)*num1(2));
delta=mean_st-mean1;
k=0.0;      %这个需要你设置成自定义的参数
temp=V1+delta+k;
HSV3(:,:,1)=H1(:,:);       %保留H不变，开始合成
HSV3(:,:,2)=S1(:,:);
HSV3(:,:,3)=temp(:,:);
normal_classroom=hsv2rgb(HSV3);    %转换回RGB空间
%imshow(normal_classroom),impixelinfo;
%title('亮度调整后图像');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
background_gray=rgb2gray(background_classroom);
normal_gray=rgb2gray(normal_classroom);
seat=zeros(10,14);
x1=970;
x2=970;
x3=1070;
x4=1070;
y1=235;
y2=255;
y3=260;
y4=240;
x_2=[x1,x2,x3,x4];
y_2=[y1,y2,y3,y4];
mask1_2=roipoly(background_gray,x_2,y_2);
mask2_2=roipoly(normal_gray,x_2,y_2);
%imshow(Initial_background_gray);
%figure,imshow(Normal_classroom_gray),figure;
mask=and(background_gray,mask1_2);
Z_1=immultiply(background_gray,mask);
mask2=and(normal_gray,mask2_2);
Z_2=immultiply(normal_gray,mask2);
%imshow(Z_1),impixelinfo,figure,imshow(Z_2),impixelinfo,figure;
Z_1=im2double(Z_1);
Z_2=im2double(Z_2);
imshow(Z_1),impixelinfo,figure,imshow(Z_2),impixelinfo;
map_area=(x4-x1)*(y2-y1);

s1=0;
s2=0;
num=size(Z_1);
for i=1:num(1)
    for j=1:num(2)
        if(abs(Z_1(i,j)-Z_2(i,j))<0.25)
            s1=s1+Z_1(i,j);
            s2=s2+Z_2(i,j);
        end
    end
end
D_value=(s1-s2)/map_area; 

Z_2=Z_2+D_value;     
detect=abs(imsubtract(Z_1,Z_2));


figure,imshow(detect),impixelinfo;
count=0;
x4_=fix(x1+(x4-x1)/3);
x1_=x1;
mark=1;
k=11;
while (x4_<=x4+10)
     for i=x1_+1:x4_
       for j=y1:y3
           jj_1=((y4-y1)/(x4-x1))*(i-x1)+y1;
           jj_2=((y4-y1)/(x4-x1))*(i-x1)+y1+(y2-y1);
           if (j>=jj_1&&j<=jj_2)
                if (detect(j,i)>0.12)
                    detect(j,i)=1;
                    count=count+1;
                else detect(j,i)=0;
                end
           end
        end
     end
   %imshow(detect),impixelinfo,figure;
   if (mark==1)
        mask_erode=[1;0;1];
        detect=imerode(detect,mask_erode);
        mark=0;
   end
    length=(x4-x1)/3;
    width=y2-y1;
    area=length*width; 
    
    if ((count/area)>0.25)
        seat(8,k)=1;
    end
    k=k+1;
    x1_=fix(x1_+(x4-x1)/3);
    x4_=fix(x1_+(x4-x1)/3);
    count=0;
end