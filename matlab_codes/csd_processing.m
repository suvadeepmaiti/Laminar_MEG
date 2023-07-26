
v_idx=5;
sim_inverted='/home/smaiti/Danc_lab/data/invert_files_by_Jimmy/multilayer_sim_at_vertex_5_layer_5_multilayer_spm-converted_no_filter_autoreject-sub-001-ses-01-001-motor-epo.mat';
gii_file='/home/smaiti/Danc_lab/data/multilayer_11.ds.link_vector.nodeep.gii';
D=spm_eeg_load(sim_inverted);


multilayer_surf = gifti(gii_file);
    
n_layers = 11;
n_vertices = size(multilayer_surf.vertices, 1);
n_vertices_per_layer = n_vertices / n_layers;


M=D.inv{1}.inverse.M;
U=D.inv{1}.inverse.U{1};
MU=M*U;

% reduce the t points and only focus on part where the signal is provided
t_idx=(D.time>=1.75) & (D.time<2.25);
csd_times=D.time(t_idx);

source_tcs=zeros(n_layers,length(find(t_idx)));
for layer=1:n_layers
    vert=(layer-1)*n_vertices_per_layer+layer;
    
    source_tcs(layer,:)=MU(vert,:)*D(D.indchantype('MEG'),find(t_idx));
    save(source_tcs);
end
