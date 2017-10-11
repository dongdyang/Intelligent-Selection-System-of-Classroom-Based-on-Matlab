background_classroom=imread('101.jpg');

for iii=1:5
    filename=sprintf('%d.jpg',iii);
    normal_classroom=imread(filename);
%文件名前缀
%prefix_T1='C:\Users\yangdongdong\Forever\projects\ClassroomQuery\';
%文件数目
%fnum =1:5;                        
%Read Image files%
%for iiii=length(fnum):-1:1
   % normal_classroom1 = [prefix_T1 num2str(fnum(iiii))
   %     ];
  %  normal_classrrom=imread(normal_classroom1);

%%%%%%%%%
%              1——9
%%%%%%%
%%imshow(Initial_background);
%impixelinfo;figure;
%normal_classroom=imread('1.jpg');
%               
%              101——104 
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
num_st=size(Vst);
mean_st=sum((sum(Vst)))/(num_st(1)*num_st(2));
num1=size(V1);
mean1=sum((sum(V1)))/(num1(1)*num1(2));
delta=mean_st-mean1;
k=0.0;      % 'k' is a variable value;
temp=V1+delta+k;
HSV3(:,:,1)=H1(:,:);    
HSV3(:,:,2)=S1(:,:);
HSV3(:,:,3)=temp(:,:);
normal_classroom=hsv2rgb(HSV3);  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
background_gray=rgb2gray(background_classroom);
normal_gray=rgb2gray(normal_classroom);
seat=zeros(10,14);
%please pay attention to "k" in line 80;it will come across the whole project;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
% line 10 on the left
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x1=120;
x2=120;
x3=530;
x4=530;
y1=300;
y2=370;
y3=370;
y4=300;
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
%imshow(Z_1),impixelinfo,figure,imshow(Z_2),impixelinfo;
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

%imshow(detect),impixelinfo;
%imshow(detect),impixelinfo;
count=0;
x4_=fix(x1+(x4-x1)/4);
x1_=x1;
mark=1;
k=1;
while (x4_<=x4+10)
     for i=x1_+1:x4_
       for j=y1:y3
           jj_1=((y4-y1)/(x4-x1))*(i-x1)+y1;
           jj_2=((y4-y1)/(x4-x1))*(i-x1)+y1+70;
           if (j>=jj_1&&j<=jj_2)
                if (detect(j,i)>0.11)
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
    length=(x4-x1)/4;
    width=y2-y1;
    area=length*width; 
    
    if ((count/area)>0.250)
        seat(10,k)=1;
    end
    k=k+1;
    x1_=fix(x1_+(x4-x1)/4);
    x4_=fix(x1_+(x4-x1)/4);
    count=0;
end


%%%%%%%%%%%%%%%%%%%%
%
% line 9 on the left
%
%%%%%%%%%%%%%%%%%%%%
x1=120;
x2=120;
x3=475;
x4=475;
y1=220;
y2=270;
y3=285;
y4=235;
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
%imshow(Z_1),impixelinfo,figure,imshow(Z_2),impixelinfo;

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


%imshow(detect),impixelinfo;
count=0;
x4_=fix(x1+(x4-x1)/4);
x1_=x1;
mark=1;
k=1;
while (x4_<=x4+10)
     for i=x1_+1:x4_
       for j=y1:y3
           jj_1=((y4-y1)/(x4-x1))*(i-x1)+y1;
           jj_2=((y4-y1)/(x4-x1))*(i-x1)+y1+50;
           if (j>=jj_1&&j<=jj_2)
                if (detect(j,i)>0.11)
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
    length=(x4-x1)/4;
    width=y2-y1;
    area=length*width; 
   
    if ((count/area)>0.25)
        seat(9,k)=1;
    end
    k=k+1;
    x1_=fix(x1_+(x4-x1)/4);
    x4_=fix(x1_+(x4-x1)/4);
    count=0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%
%
%line 8 on the left
%
%%%%%%%%%%%%%%%%%%%%%%%%%
x1=120;
x2=120;
x3=440;
x4=440;
y1=155;
y2=190;
y3=220;
y4=185;
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
%imshow(Z_1),impixelinfo,figure,imshow(Z_2),impixelinfo;

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


%imshow(detect),impixelinfo;
count=0;
x4_=fix(x1+(x4-x1)/4);
x1_=x1;
mark=1;
k=1;
while (x4_<=x4+10)
     for i=x1_+1:x4_
       for j=y1:y3
           jj_1=((y4-y1)/(x4-x1))*(i-x1)+y1;
           jj_2=((y4-y1)/(x4-x1))*(i-x1)+y1+(y2-y1);
           if (j>=jj_1&&j<=jj_2)
                if (detect(j,i)>0.11)
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
    length=(x4-x1)/4;
    width=y2-y1;
    area=length*width; 
    
    if ((count/area)>0.25)
        seat(8,k)=1;
    end
    k=k+1;
    x1_=fix(x1_+(x4-x1)/4);
    x4_=fix(x1_+(x4-x1)/4);
    count=0;
end
%%%%%%%%%%%%%%%%%%%%
%
%line 7 on the left
%
%%%%%%%%%%%%%%%%%%%%
x1=120;
x2=120;
x3=400;
x4=400;
y1=110;
y2=140;
y3=170;
y4=140;
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
%imshow(Z_1),impixelinfo,figure,imshow(Z_2),impixelinfo;

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


%imshow(detect),impixelinfo;
count=0;
x4_=fix(x1+(x4-x1)/4);
x1_=x1;
mark=1;
k=1;
while (x4_<=x4+10)
     for i=x1_+1:x4_
       for j=y1:y3
           jj_1=((y4-y1)/(x4-x1))*(i-x1)+y1;
           jj_2=((y4-y1)/(x4-x1))*(i-x1)+y1+(y2-y1);
           if (j>=jj_1&&j<=jj_2)
                if (detect(j,i)>0.11)
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
    length=(x4-x1)/4;
    width=y2-y1;
    area=length*width; 
    
    if ((count/area)>0.25)
        seat(7,k)=1;
    end
    k=k+1;
    x1_=fix(x1_+(x4-x1)/4);
    x4_=fix(x1_+(x4-x1)/4);
    count=0;
end
%%%%%%%%%%%%%%%%%%%%%
%
%line 6 on the left
%
%%%%%%%%%%%%%%%%%%%%%
x1=120;
x2=120;
x3=380;
x4=380;
y1=70;
y2=100;
y3=130;
y4=100;
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
%imshow(Z_1),impixelinfo,figure,imshow(Z_2),impixelinfo;

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


%imshow(detect),impixelinfo;
count=0;
x4_=fix(x1+(x4-x1)/4);
x1_=x1;
mark=1;
k=1;
while (x4_<=x4+10)
     for i=x1_+1:x4_
       for j=y1:y3
           jj_1=((y4-y1)/(x4-x1))*(i-x1)+y1;
           jj_2=((y4-y1)/(x4-x1))*(i-x1)+y1+(y2-y1);
           if (j>=jj_1&&j<=jj_2)
                if (detect(j,i)>0.11)
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
    length=(x4-x1)/4;
    width=y2-y1;
    area=length*width; 
    
    if ((count/area)>0.25)
        seat(6,k)=1;
    end
    k=k+1;
    x1_=fix(x1_+(x4-x1)/4);
    x4_=fix(x1_+(x4-x1)/4);
    count=0;
end
%%%%%%%%%%%%%%%%
%
% line 5 on the left
%
%%%%%%%%%%%%%%%%
x1=120;
x2=120;
x3=360;
x4=360;
y1=35;
y2=55;
y3=85;
y4=65;

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
%imshow(Z_1),impixelinfo,figure,imshow(Z_2),impixelinfo;

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


%imshow(detect),impixelinfo;
count=0;
x4_=fix(x1+(x4-x1)/4);
x1_=x1;
mark=1;
k=1;
while (x4_<=x4+10)
     for i=x1_+1:x4_
       for j=y1:y3
           jj_1=((y4-y1)/(x4-x1))*(i-x1)+y1;
           jj_2=((y4-y1)/(x4-x1))*(i-x1)+y1+(y2-y1);
           if (j>=jj_1&&j<=jj_2)
                if (detect(j,i)>0.11)
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
    length=(x4-x1)/4;
    width=y2-y1;
    area=length*width; 
    
    if ((count/area)>0.25)
        seat(5,k)=1;
    end
    k=k+1;
    x1_=fix(x1_+(x4-x1)/4);
    x4_=fix(x1_+(x4-x1)/4);
    count=0;
end
%%%%%%%%%%%%%%%%%%%%%%%
%
% line 4 on the left
%
%%%%%%%%%%%%%%%%%%%%%%%%
x1=120;
x2=120;
x3=335;
x4=335;
y1=10;
y2=25;
y3=55;
y4=40;

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
%imshow(Z_1),impixelinfo,figure,imshow(Z_2),impixelinfo;

map_area=(x4-x1)*(y2-y1);

D_value=(sum(sum(Z_1))-sum(sum(Z_2)))/map_area; 
Z_2=Z_2+D_value;     
detect=abs(imsubtract(Z_1,Z_2));


%imshow(detect),impixelinfo;
count=0;
x4_=fix(x1+(x4-x1)/4);
x1_=x1;
mark=1;
k=1;
while (x4_<=x4+10)
     for i=x1_+1:x4_
       for j=y1:y3
           jj_1=((y4-y1)/(x4-x1))*(i-x1)+y1;
           jj_2=((y4-y1)/(x4-x1))*(i-x1)+y1+(y2-y1);
           if (j>=jj_1&&j<=jj_2)
                if (detect(j,i)>0.11)
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
    length=(x4-x1)/4;
    width=y2-y1;
    area=length*width; 
    
    if ((count/area)>0.25)
        seat(4,k)=1;
    end
    k=k+1;
    x1_=fix(x1_+(x4-x1)/4);
    x4_=fix(x1_+(x4-x1)/4);
    count=0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%the following is the second line;
% line 2 on the middle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x1=415;
x2=415;
x3=625;
x4=625;
y1=20;
y2=35;
y3=70;
y4=55;
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
%imshow(Z_1),impixelinfo,figure,imshow(Z_2),impixelinfo;

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


%figure,imshow(detect),impixelinfo;
count=0;
x4_=fix(x1+(x4-x1)/6);
x1_=x1;
mark=1;
k=5;
while (x4_<=x4+10)
     for i=x1_+1:x4_
       for j=y1:y3
           jj_1=((y4-y1)/(x4-x1))*(i-x1)+y1;
           jj_2=((y4-y1)/(x4-x1))*(i-x1)+y1+(y2-y1);
           if (j>=jj_1&&j<=jj_2)
                if (detect(j,i)>0.11)
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
        mask_erode2=[1,0,1];
        detect=imerode(detect,mask_erode);
        detect=imerode(detect,mask_erode2);
        mark=0;
   end
    length=(x4-x1)/6;
    width=y2-y1;
    area=length*width; 
    
    if ((count/area)>0.25)
        seat(2,k)=1;
    end
    k=k+1;
    x1_=fix(x1_+(x4-x1)/6);
    x4_=fix(x1_+(x4-x1)/6);
    count=0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%
%
% line 3 on the middle
%
%%%%%%%%%%%%%%%%%%%%%%%%%
x1=435;
x2=435;
x3=655;
x4=655;
y1=40;
y2=55;
y3=90;
y4=75;

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
%imshow(Z_1),impixelinfo,figure,imshow(Z_2),impixelinfo;

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


%imshow(detect),impixelinfo;
count=0;
x4_=fix(x1+(x4-x1)/6);
x1_=x1;
mark=1;
k=5;
while (x4_<=x4+10)
     for i=x1_+1:x4_
       for j=y1:y3
           jj_1=((y4-y1)/(x4-x1))*(i-x1)+y1;
           jj_2=((y4-y1)/(x4-x1))*(i-x1)+y1+(y2-y1);
           if (j>=jj_1&&j<=jj_2)
                if (detect(j,i)>0.11)
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
    length=(x4-x1)/6;
    width=y2-y1;
    area=length*width; 
    
    if ((count/area)>0.25)
        seat(3,k)=1;
    end
    k=k+1;
    x1_=fix(x1_+(x4-x1)/6);
    x4_=fix(x1_+(x4-x1)/6);
    count=0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% line 4 on the middle
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x1=460;
x2=460;
x3=690;
x4=690;
y1=65;
y2=85;
y3=120;
y4=100;

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

Z_1=im2double(Z_1);
Z_2=im2double(Z_2);
%imshow(Z_1),impixelinfo,figure,imshow(Z_2),impixelinfo;

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


%imshow(detect),impixelinfo;
count=0;
x4_=fix(x1+(x4-x1)/6);
x1_=x1;
mark=1;
k=5;
while (x4_<=x4+10)
     for i=x1_+1:x4_
       for j=y1:y3
           jj_1=((y4-y1)/(x4-x1))*(i-x1)+y1;
           jj_2=((y4-y1)/(x4-x1))*(i-x1)+y1+(y2-y1);
           if (j>=jj_1&&j<=jj_2)
                if (detect(j,i)>0.11)
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
    length=(x4-x1)/6;
    width=y2-y1;
    area=length*width; 
    
    if ((count/area)>0.25)
        seat(4,k)=1;
    end
    k=k+1;
    x1_=fix(x1_+(x4-x1)/6);
    x4_=fix(x1_+(x4-x1)/6);
    count=0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% line 5 on the middle
%
%%%%%%%%%%%%%%%%%%%%%%%%%%
x1=485;
x2=485;
x3=740;
x4=740;
y1=90;
y2=110;
y3=145;
y4=125;

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
%imshow(Z_1),impixelinfo,figure,imshow(Z_2),impixelinfo;

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


%imshow(detect),impixelinfo;
count=0;
x4_=fix(x1+(x4-x1)/6);
x1_=x1;
mark=1;
k=5;
while (x4_<=x4+10)
     for i=x1_+1:x4_
       for j=y1:y3
           jj_1=((y4-y1)/(x4-x1))*(i-x1)+y1;
           jj_2=((y4-y1)/(x4-x1))*(i-x1)+y1+(y2-y1);
           if (j>=jj_1&&j<=jj_2)
                if (detect(j,i)>0.11)
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
    length=(x4-x1)/6;
    width=y2-y1;
    area=length*width; 
    
    if ((count/area)>0.25)
        seat(5,k)=1;
    end
    k=k+1;
    x1_=fix(x1_+(x4-x1)/6);
    x4_=fix(x1_+(x4-x1)/6);
    count=0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%
%
% line 6 on the middle
%
%%%%%%%%%%%%%%%%%%%%%%%%%%
x1=515;
x2=515;
x3=785;
x4=785;
y1=125;
y2=150;
y3=180;
y4=160;

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
%imshow(Z_1),impixelinfo,figure,imshow(Z_2),impixelinfo;

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


%imshow(detect),impixelinfo;
count=0;
x4_=fix(x1+(x4-x1)/6);
x1_=x1;
mark=1;
k=5;
while (x4_<=x4+10)
     for i=x1_+1:x4_
       for j=y1:y3
           jj_1=((y4-y1)/(x4-x1))*(i-x1)+y1;
           jj_2=((y4-y1)/(x4-x1))*(i-x1)+y1+(y2-y1);
           if (j>=jj_1&&j<=jj_2)
                if (detect(j,i)>0.11)
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
    length=(x4-x1)/6;
    width=y2-y1;
    area=length*width; 
    
    if ((count/area)>0.25)
        seat(6,k)=1;
    end
    k=k+1;
    x1_=fix(x1_+(x4-x1)/6);
    x4_=fix(x1_+(x4-x1)/6);
    count=0;
end
%%%%%%%%%%%%%%%%%%%%%%%%
%
% line 7 on the middle
%
%%%%%%%%%%%%%%%%%%%%%%%%
x1=550;
x2=550;
x3=830;
x4=830;
y1=165;
y2=185;
y3=215;
y4=195;

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
%imshow(Z_1),impixelinfo,figure,imshow(Z_2),impixelinfo;

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


%imshow(detect),impixelinfo;
count=0;
x4_=fix(x1+(x4-x1)/6);
x1_=x1;
mark=1;
k=5;
while (x4_<=x4+10)
     for i=x1_+1:x4_
       for j=y1:y3
           jj_1=((y4-y1)/(x4-x1))*(i-x1)+y1;
           jj_2=((y4-y1)/(x4-x1))*(i-x1)+y1+(y2-y1);
           if (j>=jj_1&&j<=jj_2)
                if (detect(j,i)>0.11)
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
    length=(x4-x1)/6;
    width=y2-y1;
    area=length*width; 
    
    if ((count/area)>0.25)
        seat(7,k)=1;
    end
    k=k+1;
    x1_=fix(x1_+(x4-x1)/6);
    x4_=fix(x1_+(x4-x1)/6);
    count=0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% line 8 on the middle
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x1=595;
x2=595;
x3=890;
x4=890;
y1=205;
y2=230;
y3=250;
y4=225;

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
%imshow(Z_1),impixelinfo,figure,imshow(Z_2),impixelinfo;

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


%imshow(detect),impixelinfo;
count=0;
x4_=fix(x1+(x4-x1)/6);
x1_=x1;
mark=1;
k=5;
while (x4_<=x4+10)
     for i=x1_+1:x4_
       for j=y1:y3
           jj_1=((y4-y1)/(x4-x1))*(i-x1)+y1;
           jj_2=((y4-y1)/(x4-x1))*(i-x1)+y1+(y2-y1);
           if (j>=jj_1&&j<=jj_2)
                if (detect(j,i)>0.11)
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
    length=(x4-x1)/6;
    width=y2-y1;
    area=length*width; 
    
    if ((count/area)>0.25)
        seat(8,k)=1;
    end
    k=k+1;
    x1_=fix(x1_+(x4-x1)/6);
    x4_=fix(x1_+(x4-x1)/6);
    count=0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% line 9 on the middle
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x1=645;
x2=645;
x3=955;
x4=955;
y1=250;
y2=285;
y3=295;
y4=265;

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
%imshow(Z_1),impixelinfo,figure,imshow(Z_2),impixelinfo;

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


%imshow(detect),impixelinfo;
count=0;
x4_=fix(x1+(x4-x1)/6);
x1_=x1;
mark=1;
k=5;
while (x4_<=x4+10)
     for i=x1_+1:x4_
       for j=y1:y3
           jj_1=((y4-y1)/(x4-x1))*(i-x1)+y1;
           jj_2=((y2-y3)/(x2-x3))*(i-x2)+y2;
           if (j>=jj_1&&j<=jj_2)
                if (detect(j,i)>0.11)
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
    length=(x4-x1)/6;
    width=y2-y1;
    area=length*width; 
    
    if ((count/area)>0.25)
        seat(9,k)=1;
    end
    k=k+1;
    x1_=fix(x1_+(x4-x1)/6);
    x4_=fix(x1_+(x4-x1)/6);
    count=0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% line 10 on the middle
%
%%%%%%%%%%%%%%%%%%%%%%%%%%
x1=720;
x2=720;
x3=1035;
x4=1035;
y1=315;
y2=360;
y3=360;
y4=315;

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
%imshow(Z_1),impixelinfo,figure,imshow(Z_2),impixelinfo;

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


%imshow(detect),impixelinfo;
count=0;
x4_=fix(x1+(x4-x1)/6);
x1_=x1;
mark=1;
k=5;
while (x4_<=x4+10)
     for i=x1_+1:x4_
       for j=y1:y3
           jj_1=((y4-y1)/(x4-x1))*(i-x1)+y1;
           jj_2=((y2-y3)/(x2-x3))*(i-x2)+y2;
           if (j>=jj_1&&j<=jj_2)
                if (detect(j,i)>0.11)
                    detect(j,i)=1;
                    count=count+1;
                else detect(j,i)=0;
                end
           end
        end
     end
   %imshow(detect),impixelinfo,figure;
   %if (mark==1)
    if(mark==1)
        mask_erode=[1 1 1 1 1;
                    1 1 0 1 1;
                    1 0 0 0 1;
                    1 1 0 1 1;
                    1 1 1 1 1];
                mask_erode2=[1 1 0 1 1];
        detect=imerode(detect,mask_erode);
        detect=imerode(detect,mask_erode2);
        mark=0;
   end
    length=(x4-x1)/6;
    width=y2-y1;
    area=length*width; 
    
    if ((count/area)>0.25)
        seat(10,k)=1;
    end
    k=k+1;
    x1_=fix(x1_+(x4-x1)/6);
    x4_=fix(x1_+(x4-x1)/6);
    count=0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% please pay attention the following 
% we will begin to analyse the right partion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x1=660;
x2=660;
x3=760;
x4=760;
y1=55;
y2=70;
y3=85;
y4=70;
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
%imshow(Z_1),impixelinfo,figure,imshow(Z_2),impixelinfo;

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
%imshow(Z_2),impixelinfo,figure;
Z_2=Z_2+D_value;     
%imshow(Z_2),impixelinfo;
detect=abs(imsubtract(Z_1,Z_2));


%imshow(detect),impixelinfo;
count=0;
x4_=fix(x1+(x4-x1)/4);
x1_=x1;
mark=1;
k=11;
while (x4_<=x4+10)
     for i=x1_+1:x4_
       for j=y1:y3
           jj_1=((y4-y1)/(x4-x1))*(i-x1)+y1;
           jj_2=((y4-y1)/(x4-x1))*(i-x1)+y1+(y2-y1);
           if (j>=jj_1&&j<=jj_2)
                if (detect(j,i)>0.11)
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
    length=(x4-x1)/4;
    width=y2-y1;
    area=length*width; 
    
    if ((count/area)>0.25)
        seat(1,k)=1;
    end
    k=k+1;
    x1_=fix(x1_+(x4-x1)/4);
    x4_=fix(x1_+(x4-x1)/4);
    count=0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% line 2 on the right
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x1=690;
x2=690;
x3=790;
x4=790;
y1=75;
y2=85;
y3=100;
y4=90;
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
%imshow(Z_1),impixelinfo,figure,imshow(Z_2),impixelinfo;

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


%imshow(detect),impixelinfo;
count=0;
x4_=fix(x1+(x4-x1)/4);
x1_=x1;
mark=1;
k=11;
while (x4_<=x4+10)
     for i=x1_+1:x4_
       for j=y1:y3
           jj_1=((y4-y1)/(x4-x1))*(i-x1)+y1;
           jj_2=((y4-y1)/(x4-x1))*(i-x1)+y1+(y2-y1);
           if (j>=jj_1&&j<=jj_2)
                if (detect(j,i)>0.11)
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
    length=(x4-x1)/4;
    width=y2-y1;
    area=length*width; 
    
    if ((count/area)>0.25)
        seat(2,k)=1;
    end
    k=k+1;
    x1_=fix(x1_+(x4-x1)/4);
    x4_=fix(x1_+(x4-x1)/4);
    count=0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% line 3 on the right
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x1=720;
x2=720;
x3=830;
x4=830;
y1=90;
y2=100;
y3=120;
y4=110;
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
%imshow(Z_1),impixelinfo,figure,imshow(Z_2),impixelinfo;

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


%imshow(detect),impixelinfo;
count=0;
x4_=fix(x1+(x4-x1)/4);
x1_=x1;
mark=1;
k=11;
while (x4_<=x4+10)
     for i=x1_+1:x4_
       for j=y1:y3
           jj_1=((y4-y1)/(x4-x1))*(i-x1)+y1;
           jj_2=((y4-y1)/(x4-x1))*(i-x1)+y1+(y2-y1);
           if (j>=jj_1&&j<=jj_2)
                if (detect(j,i)>0.11)
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
    length=(x4-x1)/4;
    width=y2-y1;
    area=length*width; 
    
    if ((count/area)>0.25)
        seat(3,k)=1;
    end
    k=k+1;
    x1_=fix(x1_+(x4-x1)/4);
    x4_=fix(x1_+(x4-x1)/4);
    count=0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% line 4 on the right
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x1=760;
x2=760;
x3=875;
x4=875;
y1=115;
y2=130;
y3=145;
y4=130;
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
%imshow(Z_1),impixelinfo,figure,imshow(Z_2),impixelinfo;

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


%imshow(detect),impixelinfo;
count=0;
x4_=fix(x1+(x4-x1)/4);
x1_=x1;
mark=1;
k=11;
while (x4_<=x4+10)
     for i=x1_+1:x4_
       for j=y1:y3
           jj_1=((y4-y1)/(x4-x1))*(i-x1)+y1;
           jj_2=((y4-y1)/(x4-x1))*(i-x1)+y1+(y2-y1);
           if (j>=jj_1&&j<=jj_2)
                if (detect(j,i)>0.11)
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
    length=(x4-x1)/4;
    width=y2-y1;
    area=length*width; 
    
    if ((count/area)>0.25)
        seat(4,k)=1;
    end
    k=k+1;
    x1_=fix(x1_+(x4-x1)/4);
    x4_=fix(x1_+(x4-x1)/4);
    count=0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% line 5 on the right
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x1=800;
x2=800;
x3=930;
x4=930;
y1=140;
y2=155;
y3=170;
y4=155;
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
%imshow(Z_1),impixelinfo,figure,imshow(Z_2),impixelinfo;

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


%imshow(detect),impixelinfo;
count=0;
x4_=fix(x1+(x4-x1)/4);
x1_=x1;
mark=1;
k=11;
while (x4_<=x4+10)
     for i=x1_+1:x4_
       for j=y1:y3
           jj_1=((y4-y1)/(x4-x1))*(i-x1)+y1;
           jj_2=((y4-y1)/(x4-x1))*(i-x1)+y1+(y2-y1);
           if (j>=jj_1&&j<=jj_2)
                if (detect(j,i)>0.11)
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
    length=(x4-x1)/4;
    width=y2-y1;
    area=length*width; 
    
    if ((count/area)>0.25)
        seat(5,k)=1;
    end
    k=k+1;
    x1_=fix(x1_+(x4-x1)/4);
    x4_=fix(x1_+(x4-x1)/4);
    count=0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%
%
% line 6 on the right
%
%%%%%%%%%%%%%%%%%%%%%%%%%
x1=850;
x2=850;
x3=975;
x4=975;
y1=170;
y2=190;
y3=205;
y4=185;
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
%imshow(Z_1),impixelinfo,figure,imshow(Z_2),impixelinfo;

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


%imshow(detect),impixelinfo;
count=0;
x4_=fix(x1+(x4-x1)/4);
x1_=x1;
mark=1;
k=11;
while (x4_<=x4+10)
     for i=x1_+1:x4_
       for j=y1:y3
           jj_1=((y4-y1)/(x4-x1))*(i-x1)+y1;
           jj_2=((y4-y1)/(x4-x1))*(i-x1)+y1+(y2-y1);
           if (j>=jj_1&&j<=jj_2)
                if (detect(j,i)>0.11)
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
    length=(x4-x1)/4;
    width=y2-y1;
    area=length*width; 
    
    if ((count/area)>0.25)
        seat(6,k)=1;
    end
    k=k+1;
    x1_=fix(x1_+(x4-x1)/4);
    x4_=fix(x1_+(x4-x1)/4);
    count=0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% line 7 on the right
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x1=900;
x2=900;
x3=1010;
x4=1010;
y1=200;
y2=220;
y3=235;
y4=215;
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
%imshow(Z_1),impixelinfo,figure,imshow(Z_2),impixelinfo;

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


%imshow(detect),impixelinfo;
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
                if (detect(j,i)>0.11)
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
        seat(7,k)=1;
    end
    k=k+1;
    x1_=fix(x1_+(x4-x1)/3);
    x4_=fix(x1_+(x4-x1)/3);
    count=0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% line 8 on the right
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%imshow(Z_1),impixelinfo,figure,imshow(Z_2),impixelinfo;
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


%imshow(detect),impixelinfo;
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
                if (detect(j,i)>0.11)
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
%%%%%%%%%%%%%%%%%%%%%%%%
%
%line 9 on the right
%
%%%%%%%%%%%%%%%%%%%%%%%%
x1=1055;
x2=1055;
x3=1170;
x4=1170;
y1=270;
y2=300;
y3=305;
y4=275;
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
%imshow(Z_1),impixelinfo,figure,imshow(Z_2),impixelinfo;

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


%imshow(detect),impixelinfo;
count=0;
x4_=fix(x1+(x4-x1)/4);
x1_=x1;
mark=1;
k=11;
while (x4_<=x4+10)
     for i=x1_+1:x4_
       for j=y1:y3
           jj_1=((y4-y1)/(x4-x1))*(i-x1)+y1;
           jj_2=((y4-y1)/(x4-x1))*(i-x1)+y1+(y2-y1);
           if (j>=jj_1&&j<=jj_2)
                if (detect(j,i)>0.11)
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
    length=(x4-x1)/4;
    width=y2-y1;
    area=length*width; 
    
    if ((count/area)>0.25)
        seat(9,k)=1;
    end
    k=k+1;
    x1_=fix(x1_+(x4-x1)/4);
    x4_=fix(x1_+(x4-x1)/4);
    count=0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%                 
%%%%%%%                       that is all seat 
%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
file=fopen('J1-101.txt','w');
people=0;
for i=1:10
    for j=1:14
        if(seat(i,j)==1);
            people=people+1;
        end
    end
end
fprintf(file,'%d\n',people);
fprintf(file,'14 10\n');
for i=1:10
    for j=1:14
        fprintf(file,'%d',seat(i,j));
    end
    fprintf(file,'\n');
end
fclose(file);
end
