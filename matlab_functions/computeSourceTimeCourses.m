function computeSourceTimeCourses(sim_inverted)
    % Loading Data
    D = spm_eeg_load(sim_inverted);

    % Loading Surface Data
    gii_file = '/home/smaiti/Danc_lab/Final_Experiments/raw_data/multilayer_11.ds.link_vector.nodeep.gii';
    multilayer_surf = gifti(gii_file);

    % Initializing Variables
    n_layers = 11;
    n_vertices = size(multilayer_surf.vertices, 1);
    n_vertices_per_layer = n_vertices / n_layers;

    % Computing Source Time Courses
    M = D.inv{1}.inverse.M;
    U = D.inv{1}.inverse.U{1};
    MU = M * U;

    t_idx = (D.time >= 1.75) & (D.time < 2.25);
    csd_times = D.time(t_idx);

    source_tcs = zeros(n_layers, length(find(t_idx)));
    for layer = 1:n_layers
        vert = (layer - 1) * n_vertices_per_layer + layer;

        source_tcs(layer, :) = MU(vert, :) * D(D.indchantype('MEG'), find(t_idx));
    end
    
    % Save the source time courses to a file
    save('/home/smaiti/Danc_lab/Final_Experiments/csd_processing_files/sim@index_20720_layer_3to9/sim@index_20720_layer9', 'source_tcs');
end