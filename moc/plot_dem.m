%M=imread('results_1mpp_big/res-DEM.tif');

light_green=[184, 224, 98]/256; % light green
mycolor = light_green;
H=mesh(double(M));
set(H, 'FaceColor', mycolor, 'EdgeColor','none', 'FaceAlpha', 1);
set(H, 'SpecularColorReflectance', 0.1, 'DiffuseStrength', 0.8);
set(H, 'FaceLighting', 'phong', 'AmbientStrength', 0.3);
set(H, 'SpecularExponent', 108);

%daspect([1 1 1]);
%axis tight;
%colormap(prism(28))

% add in a source of light
camlight (-50, 54);
lighting phong;

view(-150, 66);
