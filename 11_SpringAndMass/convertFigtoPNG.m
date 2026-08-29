% Set the folder path (current folder by default)
folderPath = "/Users/suraj/Library/CloudStorage/OneDrive-PlakshaUniversity/Classes/Sem6/RMath/RMath-Tutorials/RMath-HW04/11_SpringAndMass/imgs/clustering"; 

% Get a list of all .fig files in the folder
figFiles = dir(fullfile(folderPath, '*.fig'));

% Loop through each file
for i = 1:length(figFiles)
    % Get the file name and full path
    [~, fileName, ~] = fileparts(figFiles(i).name);
    fullFigPath = fullfile(folderPath, figFiles(i).name);
    
    % Open the figure invisibly
    fig = openfig(fullFigPath, 'invisible');
    
    % Define the output name (same name, .png extension)
    outputName = fullfile(folderPath, [fileName, '.png']);
    
    % Save the figure as a PNG
    % 'saveas' is easy, but 'exportgraphics' often provides better resolution
    exportgraphics(fig, outputName, 'Resolution', 300);
    
    % Close the figure to free up memory
    close(fig);
    
    fprintf('Converted: %s.fig -> %s.png\n', fileName, fileName);
end

disp('Conversion complete!');