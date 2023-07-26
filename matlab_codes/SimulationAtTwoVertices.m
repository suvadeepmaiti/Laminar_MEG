function SimulationAtTwoVertices(epo_file, gii_file, vertex1_layer, vertex1_index, vertex2_layer, vertex2_index)
    spm('defaults','eeg');
    
    D = spm_eeg_load(epo_file);
    multilayer_surf = gifti(gii_file);
    
    n_layers = 11;
    n_vertices = size(multilayer_surf.vertices, 1);
    n_vertices_per_layer = n_vertices / n_layers;
    
    pref = sprintf('sim_at_vertices_layer%d_vertex%d_layer%d_vertex%d_', vertex1_layer, vertex1_index, vertex2_layer, vertex2_index);
    
    mesh_vertex1 = (vertex1_layer - 1) * n_vertices_per_layer + vertex1_index;
    mesh_vertex2 = (vertex2_layer - 1) * n_vertices_per_layer + vertex2_index;
    
    simpos = [D.inv{1}.mesh.tess_mni.vert(mesh_vertex1,:); D.inv{1}.mesh.tess_mni.vert(mesh_vertex2,:)];

    % Normalize ormni to unit length
    ormni = [multilayer_surf.normals(mesh_vertex1,:); multilayer_surf.normals(mesh_vertex2,:)];
    ormni = ormni ./ vecnorm(ormni, 2, 2);
    nAmdipmom = [1; 1];  % Specify the number of sources for each position
    
    
    woi = [D.time(1) - (D.time(2) - D.time(1)), D.time(end)];
    zero_time = D.time((length(D.time) - 1) / 2 + 1);
    signal_width = 0.025; % 25ms
    signal = exp(-((D.time - zero_time).^2) / (2 * signal_width^2));
    simsignal = repmat(signal, 2, 1);    
    dipfwhm = 5;
    SNRdB = -20;
    
    [Dsim, ~] = spm_eeg_simulate({D}, pref, simpos, simsignal, ormni, woi, [], SNRdB, [], [], dipfwhm, nAmdipmom, []);    
    save(Dsim);
end