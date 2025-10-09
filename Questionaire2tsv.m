% Read questionaire xls data and export as tsv files

% Define input and output folders
infldr  = 'D:\data\Original\post_TES_questionairs';
outfldr = 'D:\data\BIDS';

% Ensure output folder exists
if ~exist(outfldr, 'dir')
    mkdir(outfldr);
end

% Get list of all Excel files matching your pattern
files = dir(fullfile(infldr, 'S*_TES_questionaire.xlsx'));

% Loop through each file
for k = 1:numel(files)
    % Full paths for reading and writing
    infile    = fullfile(infldr,  files(k).name);
    [~, base] = fileparts(files(k).name);
    bids_base = ['sub-L18_' base(1:3)];
    outfile   = fullfile([outfldr '\' bids_base '\beh\'], [bids_base(1:end-4) '_' base '.tsv']);
    
    % Read the spreadsheet into a table (preserve original names)
    T = readtable(infile, 'PreserveVariableNames', true);
    
    % Delete columns 15 and 16
    T(:, 15:16) = [];

    % Identify numeric columns
    isNumVar = varfun(@isnumeric, T, 'OutputFormat', 'uniform');
    
    % Fill missing in numeric columns with 0
    T(:, isNumVar) = fillmissing(T(:, isNumVar), 'constant', 0);
    
    % Fill missing in string or cell columns with "0"
    strCols = find(~isNumVar);
    for j = strCols
        col = T.(j);
        mask = ismissing(col);
        if iscell(col)
            col(mask) = {0};
        elseif isstring(col)
            col(mask) = "0";
        end
        T.(j) = col;
    end
    
    
    
    % Write out as a TSV
    writetable(...
        T, ...
        outfile, ...
        'Delimiter', '\t', ...
        'FileType', 'text', ...
        'WriteVariableNames', true ...
    );
    
    fprintf('Converted %s → %s\n', files(k).name, [base '.tsv']);
end


