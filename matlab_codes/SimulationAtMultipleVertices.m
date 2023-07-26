function SimulationAtMultipleVertices(epo_file, gii_file, vertex_layers, vertex_indices)
    spm('defaults', 'eeg');
    
    % load the EEG data
    D = spm_eeg_load(epo_file);
    
    % load the cortical surface
    multilayer_surf = gifti(gii_file);
    
    % calculate number of vertices per layer
    n_layers = 11;
    n_vertices = size(multilayer_surf.vertices, 1);
    n_vertices_per_layer = n_vertices / n_layers;
    
    % calculate the total number of vertices
    n_vertices_total = numel(vertex_layers);
    
    % prefix string for naming the output files generated
    pref = 'sim_at_multiple_vertices_';
    
    % empty arrays to store the simulated positions, orientations, and number of sources for each vertex.
    simpos = zeros(n_vertices_total, 3);
    ormni = zeros(n_vertices_total, 3);
    nAmdipmom = zeros(n_vertices_total, 1);
    
    % retrieve the layer and index values for the current vertex and calculate the mesh_vertex index
    for i = 1:n_vertices_total
        layer = vertex_layers(i);
        index = vertex_indices(i);
        mesh_vertex = (layer - 1) * n_vertices_per_layer + index;
        
        %store the MNI coordinates ('simpos') and surface normals ('ormni') for the current mesh_vertex in the corresponding arrays.
        simpos(i, :) = D.inv{1}.mesh.tess_mni.vert(mesh_vertex, :);
        ormni(i, :) = multilayer_surf.normals(mesh_vertex, :);
        
        % Specify the number of sources for each position
        nAmdipmom(i) = 1;  
    end
    
    
    woi = [D.time(1) - (D.time(2) - D.time(1)), D.time(end)];
    zero_time = D.time((length(D.time) - 1) / 2 + 1);
    signal_width = 0.025; % 25ms
    signal = exp(-((D.time - zero_time).^2) / (2 * signal_width^2));
    simsignal = repmat(signal, n_vertices_total, 1);
    
    dipfwhm = 5;
    SNRdB = -20;
    
    [Dsim, ~] = spm_eeg_simulate({D}, pref, simpos, simsignal, ormni, woi, [], SNRdB, [], [], dipfwhm, nAmdipmom, []);
    
    % save the simulated data
    save(Dsim);
end
