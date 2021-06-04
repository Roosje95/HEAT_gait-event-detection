# Heatmaps for gait event detection
In this repository the codes connected to Visscher et al "Impact of the marker set configuration on the accuracy of gait event detection in healthy and pathological subjects" are provided. 

a_MAIN contains the script in which the gait events (initial contact - IC, and toe-off - TO) are estimated throught different kinematic functions (Ghoussayni et al., Zeni et al., Dessailly et al., Hsue et al. and Hreljac et al.) and force plate detection.
b_script_groups contains teh script used to perform the grouping of the patients in groups G1-G4 based on the position o fthe foot in mid-stance. The solde angle as well as the varus angle are calculated.
c_BA contains teh script used to evaluate the agreement between kinematic and kinetic gait event estimation by calculating the median errors and 95% confidence interfals.

In the heatmap folder contains the codes used to create the heatmaps presented within the paper. After creating the heatmaps with matlab, the heatmaps were exported as PDFs and figures for the paper were created by adapting the heatmaps with Affinity designer.

In the output folder contains the matlab structs with error values and statistical results from the data presented within the paper.

The markerklebung pdf contains the marker set used within our local gait lab.

These codes are created with: Marie Freslier, Florent Moissenet, Sailee Sansgiri. This work would not have been possilbe without the immense support by the gait lab staff of the University Children's Hospital Basel (UKBB) and the financial support from the Ralf-Loddenkemper Foundation.

In case of questions please contact: bt@ethz.ch. 
