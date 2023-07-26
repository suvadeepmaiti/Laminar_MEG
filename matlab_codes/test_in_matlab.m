spm('defaults','eeg');
g=gifti('/home/smaiti/Danc_lab/data/multilayer_11.ds.link_vector.nodeep.gii');
g
g = 

  struct with fields:

       faces: [659046×3 int32]
         mat: [4×4 double]
     normals: [353826×3 single]
    vertices: [353826×3 single]

plot(g);
Warning: cameramenu will be removed in a future release.  Use
cameratoolbar instead. 
Reference to non-existent field 'figLastLastPoint'.

Error in cameramenu (line 170)
  deltaPix  = pt-Udata.figLastLastPoint;
 
Error while evaluating Figure WindowButtonUpFcn.

n_surfs=11;

verts_per_surf=size(g.vertices,1)/n_surfs

verts_per_surf =

       32166

size(g.vertices,1)

ans =

      353826

verts_per_surf

verts_per_surf =

       32166

p_idx=500;

