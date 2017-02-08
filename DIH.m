I1=imread('01.jpg'); 
I=imcrop(I1);
I=double(I);   
I=I(:,:,1);
c1=25; k=1;
c2=200; 
% m=2; 
[r,c]=size(I); 
I1=zeros(r,c); 
I2=zeros(r,c);
for i=1:2 
    for i=1:r        
        for j=1:c        
            u1(k)=1./(((I(i,j)-c1)./(I(i,j)-c1)).^2+((I(i,j)-c1)./(I(i,j)-c2)).^2);  
            if(isnan(u1(k)))       
                u1(k)=1;        
            end
            u2(k)=1./(((I(i,j)-c2)./(I(i,j)-c1)).^2+((I(i,j)-c2)./(I(i,j)-c2)).^2);  
            if(isnan(u2(k)))        
                u2(k)=1;        
            end
            k=k+1;    
        end
    end
    U=[u1;u2;u1+u2]';
    k=1;
    sum1=0;sum2=0;sum3=0;sum4=0;
    for i=1:r    
        for j=1:c 
            sum1=sum1+((u1(k).^2).*I(i,j));sum2=sum2+(u1(k).^2);
            sum3=sum3+((u2(k).^2).*I(i,j));sum4=sum4+(u2(k).^2);
            k=k+1;    
        end
    end
    cc1=sum1/sum2; 
    cc2=sum3/sum4; 
    c1=cc1; c2=cc2; 
    k=1; 
    for i=1:r  
        for j=1:c
        if u1(k)>= 0.3  
            I1(i,j)=I(i,j);   
        else
            I2(i,j)=I(i,j);   
        end
        k=k+1;
        end
    end
end
z=imadd(I1,I2);
figure,imshow(I1,[]);
figure,imshow(I2,[]);
% above code is for image segmentation
 
% Code for Bias field Estimation for the segment 1 Image
D=imresize(I1, [416 416]); 
% imshow( D ); 
% 
[ny, nx] = size( D ); 
D=double(D); 
% Define the degree of the basis functions for the x and y directions
% 
degreeX = 5; 
degreeY = 1; 
% 
% The function call dop uses the number of basis functions not degree 
% 
noBfsX = degreeX + 1; noBfsY = degreeY + 1; 
% 
% Generate the discrete orthogonal basis functions 
%
Bx = dop( nx, noBfsX ); By = dop( ny, noBfsY );
% 
Sp = By' * D * Bx;           
% 
% generate scale vectors for the x and y directions 
%
%
%
xScale = 0:degreeX; 
%
yScale = 0:degreeY; 
%
% \caption{2D polynomial spectrum} 
%
Z = By * Sp * Bx'; 
%
fig3 = figure;
imagesc( Z ); 
% 
colorbar; 
colormap(gray); 
title('bias field of segment 1');
C = D - Z;
fig4 = figure; 
imagesc( C ); 
colorbar;
colormap(gray);
title('bias removed image segment'); 
GLCM2 = graycomatrix(Z); 
stats = graycoprops(GLCM2,{'energy'}); 
  % Code for Bias field Estimation for the segment 2 Image 
  D1=imresize(I2, [416 416]); 
  % imshow( D1 ); 
  %
  [ny, nx] = size( D1 ); 
  D1=double(D1); 
  %
  D=ones(416, 416); 
  %
  % Define the degree of the basis functions for the x and y directions
  %
  degreeX = 5;
  degreeY = 1; 
  %
  % The function call dop uses the number of basis functions not degree 
  %
  noBfsX = degreeX + 1;
  noBfsY = degreeY + 1;
  %
  % Generate the discrete orthogonal basis functions 
  %
  Bx = dop( nx, noBfsX );
  By = dop( ny, noBfsY );
  %
  Sp = By' * D1 * Bx;          
  %
  % generate scale vectors for the x and y directions 
  %
  %
  % 
  xScale = 0:degreeX; 
  %
  yScale = 0:degreeY; 
  Z1 = By * Sp * Bx'; 
  %
  fig3 = figure; 
  imagesc( Z1 ); 
  %
  colorbar;
  colormap(gray); 
  title('bias field of segment 2'); 
  %
  C1 = D1 - Z1;  
  fig4 = figure;
  imagesc( C1 ); 
  colorbar; 
  colormap(gray);
  title('bias removed image segment 2');
  GLCM2 = graycomatrix(Z1);
  stats = graycoprops(GLCM2,{'energy'}); 
  %% inhomogenity obtained from orignal image Iref 
  y1=imadd(C,C1); 
  figure,imshow(y1,[]); 
  title('Bias Corrected Image');
