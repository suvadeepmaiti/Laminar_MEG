function SimuAtOneVertex(epo_file, gii_file, sim_vertices, sim_layers)
    spm('defaults','eeg');

    D = spm_eeg_load(epo_file);
    multilayer_surf = gifti(gii_file);

    n_layers = 11;
    n_vertices = size(multilayer_surf.vertices, 1);
    n_vertices_per_layer = n_vertices / n_layers;

    % Loop over the given simulation vertices and layers
    for i = 1:length(sim_vertices)
        sim_vertex = sim_vertices(i);
        sim_layer = sim_layers(i);

        pref = sprintf('/home/smaiti/Danc_lab/Final_Experiments/simulated_data/sim_at_ONE_vertex_20720_layers3to9/sim_at_vertex_%d_layer_%d_', sim_vertex, sim_layer);

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
        SNRdB = -10;

        [Dsim, ~] = spm_eeg_simulate({D}, pref, simpos, simsignal, ormni, woi, [], SNRdB, [], [], dipfwhm, nAmdipmom, []);

        % Save the simulation data in the specified file path
        save(Dsim);
    end
end