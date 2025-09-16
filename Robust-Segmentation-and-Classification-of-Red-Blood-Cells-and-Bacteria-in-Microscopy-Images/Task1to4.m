clear; close all;

% Task 1: Pre-processing -----------------------
% Step-1: Load input image
I = imread('IMG_01.png');
figure, imshow(I)

% Step-2: Covert image to grayscale
I_gray = rgb2gray(I);
figure, imshow(I_gray)

% Step-3: Rescale image
height = 512;
aspectRatio = size(I_gray, 2) / size(I_gray, 1);
width = round(height * aspectRatio);
I_resized = imresize(I_gray, [height width]);
figure, imshow(I_resized);

% Step-4: Produce histogram before enhancing
figure, imhist(I_resized, 64);

% Step-5: Enhance image before binarisation
I_enhanced = imadjust(I_resized);
figure, imshow(I_enhanced);

% Step-6: Histogram after enhancement
figure, imhist(I_enhanced, 64);

% Step-7: Image Binarisation
threshold = graythresh(I_enhanced);
I_binary = imbinarize(I_enhanced, threshold);
figure, imshow(I_binary)


% Task 2: Edge detection ------------------------
edges = edge(I_enhanced, 'Canny');
figure, imshow(edges)

% Task 3: Simple segmentation --------------------

% Step 1: Clean up the image
se = strel('disk', 2);  
I_cleaned = imopen(I_binary, se);  
I_filled = imfill(I_cleaned, 'holes');  

% Step 2: Create a new binary image with white circles
I_circles = false(size(I_filled));
cc = bwconncomp(I_filled);  
stats = regionprops(cc, 'Centroid', 'EquivDiameter');

for k = 1:length(stats)
    radius = stats(k).EquivDiameter / 2;
    [xGrid, yGrid] = meshgrid(1:size(I_filled, 2), 1:size(I_filled, 1));
    circleMask = (xGrid - stats(k).Centroid(1)).^2 + (yGrid - stats(k).Centroid(2)).^2 <= radius^2;
    I_circles(circleMask) = 1;
end
figure, imshow(I_circles);  

% Task 4: Object Recognition --------------------
I = imread('IMG_11.png');
figure, imshow(I);



