function SimulationAtOneVertex(epo_file, gii_file, sim_vertex, sim_layer)
    spm('defaults','eeg');
    
    D = spm_eeg_load(epo_file);
    multilayer_surf = gifti(gii_file);
    
    n_layers = 11;
    n_vertices = size(multilayer_surf.vertices, 1);
    n_vertices_per_layer = n_vertices / n_layers;
    
    pref = 'sim_func_';
    
    mesh_vertex = (sim_layer - 1) * n_vertices_per_layer + sim_vertex;
    
    simpos = D.inv{1}.mesh.tess_mni.vert(mesh_vertex,:);
    ormni = multilayer_surf.normals(mesh_vertex,:);
    nAmdipmom = 6;
    
    woi = [D.time(1) - (D.time(2) - D.time(1)), D.time(end)];
    zero_time = D.time((length(D.time) - 1) / 2 + 1);
    signal_width = 0.025; % 25ms
    signal = exp(-((D.time - zero_time).^2) / (2 * signal_width^2));
    simsignal = signal;
    
    dipfwhm = 5;
    SNRdB = -20;
    
    [Dsim, meshsourceind] = spm_eeg_simulate({D}, pref, simpos, simsignal, ormni, woi, [], SNRdB, [], [], dipfwhm, nAmdipmom, []);
    
    save(Dsim);
end