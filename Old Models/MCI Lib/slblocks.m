function blkStruct = slblocks
% Function to add a specific custom library to the Library Browser

% Author: Phil Goddard (phil@goddardconsulting.ca)

% Define how the custom library is displayed in the Library Browser
Browser.Library = 'mci_models'; % Name of the .mdl file
Browser.Name    = 'MCI Models';
Browser.IsFlat  = 0; % Is this library "flat" (i.e. no subsystems)?

% Define how the custom library is displayed in the older style
% "Blocksets and Toolboxes" view.
blkStruct.Name = ['MCI Models' sprintf('\n') 'Library'];
blkStruct.OpenFcn = 'mci_models'; % Name of the .mdl file
blkStruct.MaskDisplay = '';

% Output the required structure
blkStruct.Browser = Browser;