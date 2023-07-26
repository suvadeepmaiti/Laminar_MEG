function performInversion(folder_path, output_dir, participants_tsv, t1_file, link_vector, layers, sub)
    % Get a list of all files in the folder
    file_list = dir(folder_path);
    mat_file_list = {};

    % Iterate through each file in the folder
    for i = 1:numel(file_list)
        file_name = file_list(i).name;
        if endsWith(file_name, '.mat')
            % Add the file to the list
            mat_file_list = [mat_file_list; file_name];
        end
    end

    for i = 1:numel(mat_file_list)
        mat_file = fullfile(folder_path, mat_file_list{i});

        % Create a unique folder for each file
        [~, mat_file_name, ~] = fileparts(mat_file);
        folder_name = fullfile(output_dir, mat_file_name);
        mkdir(folder_name);
        mu_file = fullfile(folder_name, [mat_file_name '_MU.tsv']);
        it_file = fullfile(folder_name, [mat_file_name '_It.tsv']);
        json_out_file = fullfile(folder_name, [mat_file_name '.json']);

        invert_multisurface(output_dir, participants_tsv, mat_file, t1_file, link_vector, mu_file, it_file, json_out_file, layers, sub);
    end
end